//
//  BodyMeasurementViewModel.swift
//  TailorFitiOS
//
//  Created by admin63 on 28/10/24.
//


class BodyMeasurementViewModel: ObservableObject {
    @Published var measurements: BodyMeasurements?
    @Published var processingImage = false
    private let knownDistance: Double // Distance in meters
    private let focalLength: Double // Camera focal length
    
    init(knownDistance: Double = 2.0, focalLength: Double = 28.0) {
        self.knownDistance = knownDistance
        self.focalLength = focalLength
    }
    
    func processImage(_ image: UIImage) {
        processingImage = true
        
        guard let cgImage = image.cgImage else {
            processingImage = false
            return
        }
        
        // Create Vision request for human body pose detection
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard let observations = request.results as? [VNHumanBodyPoseObservation],
                  let observation = observations.first else {
                DispatchQueue.main.async {
                    self?.processingImage = false
                }
                return
            }
            
            self?.processBodyPoseObservation(observation, imageSize: CGSize(width: cgImage.width, height: cgImage.height))
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    private func processBodyPoseObservation(_ observation: VNHumanBodyPoseObservation, imageSize: CGSize) {
        // Extract keypoints
        let keypoints = try? observation.recognizedPoints(.all)
        
        guard let rightShoulder = keypoints?[.rightShoulder],
              let leftShoulder = keypoints?[.leftShoulder],
              let rightHip = keypoints?[.rightHip],
              let leftHip = keypoints?[.leftHip],
              let rightAnkle = keypoints?[.rightAnkle],
              let rightWrist = keypoints?[.rightWrist] else {
            DispatchQueue.main.async {
                self.processingImage = false
            }
            return
        }
        
        // Calculate measurements
        let shoulderWidth = distance(from: rightShoulder.location, to: leftShoulder.location)
        let hipWidth = distance(from: rightHip.location, to: leftHip.location)
        let armLength = distance(from: rightShoulder.location, to: rightWrist.location)
        let inseam = distance(from: rightHip.location, to: rightAnkle.location)
        
        // Convert pixel measurements to real-world measurements using known distance
        let pixelToMeterRatio = knownDistance / Double(imageSize.width)
        
        let measurements = BodyMeasurements(
            chest: shoulderWidth * pixelToMeterRatio * 100, // Convert to centimeters
            waist: hipWidth * pixelToMeterRatio * 100,
            armLength: armLength * pixelToMeterRatio * 100,
            inseam: inseam * pixelToMeterRatio * 100
        )
        
        DispatchQueue.main.async {
            self.measurements = measurements
            self.processingImage = false
        }
    }
    
    private func distance(from point1: CGPoint, to point2: CGPoint) -> Double {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
}