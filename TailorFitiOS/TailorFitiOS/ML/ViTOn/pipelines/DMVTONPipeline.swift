//
//  DMVTONPipeline.swift
//  TailorFitiOS
//
//  Created by admin63 on 05/11/24.
//


import TensorFlow

class DMVTONPipeline {
    var alignCorners: Bool
    var warpModel: MobileAFWM
    var genModel: MobileNetV2_unet

    init(alignCorners: Bool = true, checkpoints: [String: String]? = nil) {
        self.alignCorners = alignCorners
        self.warpModel = MobileAFWM(inputChannels: 3, alignCorners: alignCorners)
        self.genModel = MobileNetV2_unet(inputChannels: 7, outputChannels: 4)
        
        if let checkpoints = checkpoints {
            loadPretrained(checkpoints: checkpoints)
        }
    }

    private func loadPretrained(checkpoints: [String: String]) {
        if let warpCheckpoint = checkpoints["warp"] {
            self.warpModel.loadWeights(from: warpCheckpoint)
        }
        if let genCheckpoint = checkpoints["gen"] {
            self.genModel.loadWeights(from: genCheckpoint)
        }
    }

    func forward(person: Tensor<Float>, clothes: Tensor<Float>, clothesEdge: Tensor<Float>, phase: String = "test") -> (Tensor<Float>, Tensor<Float>) {
        let clothesEdgeThresholded = clothesEdge .> Tensor(0.5)
        let clothesProcessed = clothes * clothesEdgeThresholded

        // Warp model
        let flowOut = warpModel(person: person, clothes: clothesProcessed, phase: phase)
        let warpedCloth = flowOut.0
        let lastFlow = flowOut.1

        let warpedEdge = clothesEdgeThresholded.gridSample(grid: lastFlow.permuted([0, 2, 3, 1]), mode: .bilinear, paddingMode: .zeros, alignCorners: alignCorners)

        // Gen model
        let genInputs = Tensor(concatenating: [person, warpedCloth, warpedEdge], alongAxis: 1)
        let genOutputs = genModel(genInputs)
        let pRendered = tanh(genOutputs.slice(lowerBounds: [0, 0], sizes: [3]))
        let mComposite = sigmoid(genOutputs.slice(lowerBounds: [3, 1], sizes: [1])) * warpedEdge

        let pTryon = (warpedCloth * mComposite) + (pRendered * (1 - mComposite))
        return (pTryon, warpedCloth)
    }
}
