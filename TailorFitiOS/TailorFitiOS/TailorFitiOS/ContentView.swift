//
//  ContentView.swift
//  TailorFitiOS
//
//  Created by admin63 on 27/09/24.
//

import SwiftUICore
import SwiftUI
//import SwiftUI
//import AVFoundation
//
//struct ContentView: View {
//    @State private var selectedTab = 0
//    @State private var showCamera = false
//    @State private var showingShareSheet = false
//    @State private var capturedImage: UIImage?
//    @State private var measurements: Measurements?
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            MeasureTab(showCamera: $showCamera,
//                      capturedImage: $capturedImage,
//                      measurements: $measurements,
//                      showingShareSheet: $showingShareSheet)
//                .tabItem {
//                    Image(systemName: "ruler")
//                    Text("Measure")
//                }
//                .tag(0)
//            
//            VirtualTryOnTab()
//                .tabItem {
//                    Image(systemName: "tshirt")
//                    Text("Virtual Try On")
//                }
//                .tag(1)
//        }
//    }
//}
//
//struct MeasureTab: View {
//    @Binding var showCamera: Bool
//    @Binding var capturedImage: UIImage?
//    @Binding var measurements: Measurements?
//    @Binding var showingShareSheet: Bool
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = capturedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .padding()
//                    
//                    if let measurements = measurements {
//                        MeasurementsView(measurements: measurements)
//                    }
//                    
//                    HStack(spacing: 20) {
//                        Button("Update") {
//                            showCamera = true
//                        }
//                        .buttonStyle(.bordered)
//                        
//                        Button("Share") {
//                            showingShareSheet = true
//                        }
//                        .buttonStyle(.bordered)
//                    }
//                } else {
//                    VStack {
//                        Image(systemName: "camera")
//                            .font(.system(size: 60))
//                            .padding()
//                        
//                        Text("Take a photo to get started")
//                            .font(.headline)
//                        
//                        Button("Start Scan") {
//                            showCamera = true
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .padding()
//                    }
//                }
//            }
//            .navigationTitle("Body Measurements")
//            .sheet(isPresented: $showCamera) {
//                CameraView(image: $capturedImage, measurements: $measurements)
//            }
//            .sheet(isPresented: $showingShareSheet) {
//                if let measurements = measurements {
//                    ShareSheet(items: [measurements.toShareString()])
//                }
//            }
//        }
//    }
//}
//
//struct VirtualTryOnTab: View {
//    @State private var showImagePicker = false
//    @State private var selectedImage: UIImage?
//    @State private var showingShareSheet = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .padding()
//                    
//                    HStack(spacing: 20) {
//                        Button("Regenerate") {
//                            // Add regeneration logic
//                        }
//                        .buttonStyle(.bordered)
//                        
//                        Button("Share") {
//                            showingShareSheet = true
//                        }
//                        .buttonStyle(.bordered)
//                    }
//                } else {
//                    VStack {
//                        Image(systemName: "photo")
//                            .font(.system(size: 60))
//                            .padding()
//                        
//                        Text("Upload or capture an image")
//                            .font(.headline)
//                        
//                        HStack(spacing: 20) {
//                            Button("Upload") {
//                                showImagePicker = true
//                            }
//                            .buttonStyle(.bordered)
//                            
//                            Button("Capture") {
//                                showImagePicker = true
//                            }
//                            .buttonStyle(.bordered)
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationTitle("Virtual Try On")
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(image: $selectedImage)
//            }
//            .sheet(isPresented: $showingShareSheet) {
//                if let image = selectedImage {
//                    ShareSheet(items: [image])
//                }
//            }
//        }
//    }
//}
//
//// Supporting Views and Models
//
//struct CameraView: View {
//    @Binding var image: UIImage?
//    @Binding var measurements: Measurements?
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        // Implement camera functionality
//        Text("Camera View")
//    }
//}
//
//struct ImagePicker: View {
//    @Binding var image: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        // Implement image picker functionality
//        Text("Image Picker View")
//    }
//}
//
//struct ShareSheet: UIViewControllerRepresentable {
//    let items: [Any]
//    
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: items, applicationActivities: nil)
//    }
//    
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}
//
//struct MeasurementsView: View {
//    let measurements: Measurements
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Chest: \(measurements.chest)cm")
//            Text("Waist: \(measurements.waist)cm")
//            Text("Hips: \(measurements.hips)cm")
//            Text("Inseam: \(measurements.inseam)cm")
//        }
//        .padding()
//    }
//}
//
//struct Measurements {
//    var chest: Double
//    var waist: Double
//    var hips: Double
//    var inseam: Double
//    
//    func toShareString() -> String {
//        """
//        TailorFit Measurements:
//        Chest: \(chest)cm
//        Waist: \(waist)cm
//        Hips: \(hips)cm
//        Inseam: \(inseam)cm
//        """
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

//struct ContentView: View {
//    @StateObject private var viewModel = BodyMeasurementViewModel()
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    @State private var showingMeasurements = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = inputImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxHeight: 400)
//                }
//                
//                Button(action: {
//                    showingImagePicker = true
//                }) {
//                    Text("Select Image")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding()
//                
//                if viewModel.processingImage {
//                    ProgressView("Processing...")
//                }
//            }
//            .navigationTitle("Body Measurements")
//            .sheet(isPresented: $showingImagePicker) {
//                ImagePicker(image: $inputImage)
//            }
//            .onChange(of: inputImage) { _ in
//                if let image = inputImage {
//                    viewModel.processImage(image)
//                    showingMeasurements = true
//                }
//            }
//            .sheet(isPresented: $showingMeasurements) {
//                MeasurementsView(measurements: viewModel.measurements)
//            }
//        }
//    }
//}
//
//struct MeasurementsView: View {
//    let measurements: BodyMeasurements?
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        NavigationView {
//            if let measurements = measurements {
//                List {
//                    Section(header: Text("Body Measurements")) {
//                        HStack {
//                            Text("Chest")
//                            Spacer()
//                            Text(String(format: "%.1f cm", measurements.chest))
//                        }
//                        
//                        HStack {
//                            Text("Waist")
//                            Spacer()
//                            Text(String(format: "%.1f cm", measurements.waist))
//                        }
//                        
//                        HStack {
//                            Text("Arm Length")
//                            Spacer()
//                            Text(String(format: "%.1f cm", measurements.armLength))
//                        }
//                        
//                        HStack {
//                            Text("Inseam")
//                            Spacer()
//                            Text(String(format: "%.1f cm", measurements.inseam))
//                        }
//                    }
//                    
//                    Section(header: Text("Recommended Size")) {
//                        HStack {
//                            Text("Size")
//                            Spacer()
//                            Text(measurements.size)
//                                .bold()
//                        }
//                    }
//                }
//                .navigationTitle("Results")
//                .navigationBarItems(trailing: Button("Done") {
//                    presentationMode.wrappedValue.dismiss()
//                })
//            } else {
//                Text("No measurements available")
//            }
//        }
//    }
//}

import SwiftUI
import Vision
import AVFoundation

// MARK: - Models
struct BodyMeasurements {
    var chest: Double
    var waist: Double
    var armLength: Double
    var inseam: Double
    
    var size: String {
        // Simple size calculation based on chest measurement (you can make this more sophisticated)
        switch chest {
        case ..<90: return "S"
        case 90..<100: return "M"
        case 100..<110: return "L"
        case 110..<120: return "XL"
        default: return "XXL"
        }
    }
}

struct Keypoint {
    var location: CGPoint
    var confidence: Float
}

// MARK: - View Model
@MainActor
final class BodyMeasurementViewModel: ObservableObject {
    @Published var measurements: BodyMeasurements?
    @Published var processingImage = false
    private let knownDistance: Double // Distance in meters
    private let focalLength: Double // Camera focal length
    
    init(knownDistance: Double = 2.0, focalLength: Double = 28.0) {
        self.knownDistance = knownDistance
        self.focalLength = focalLength
    }
    
    @MainActor
    func processImage(_ image: UIImage) {
        processingImage = true
        
        guard let cgImage = image.cgImage else {
            processingImage = false
            return
        }
        
        // Create request configuration with proper orientation
        let config = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        
        // Create Vision request for human body pose detection
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            if let error = error {
                print("Vision error: \(error.localizedDescription)")
                Task { @MainActor in
                    self?.processingImage = false
                }
                return
            }
            
            guard let observations = request.results as? [VNHumanBodyPoseObservation],
                  let observation = observations.first else {
                print("No body pose detected")
                Task { @MainActor in
                    self?.processingImage = false
                }
                return
            }
            
            print("Detected body pose with confidence: \(observation.confidence)")
            self?.processBodyPoseObservation(observation, imageSize: CGSize(width: cgImage.width, height: cgImage.height))
        }
        
        Task {
            do {
                // Perform the request
                try config.perform([request])
            } catch {
                print("Error performing vision request: \(error)")
                await MainActor.run {
                    self.processingImage = false
                }
            }
        }
    }
    private func processBodyPoseObservation(_ observation: VNHumanBodyPoseObservation, imageSize: CGSize) {
        do {
            // Get recognized points
            let recognizedPoints = try observation.recognizedPoints(.all)
            
            // Convert normalized points to image coordinates
            func convertPoint(_ point: VNRecognizedPoint) -> CGPoint {
                CGPoint(x: point.location.x * imageSize.width,
                       y: (1 - point.location.y) * imageSize.height) // Flip y coordinate
            }
            
            guard let rightShoulder = recognizedPoints[.rightShoulder],
                  let leftShoulder = recognizedPoints[.leftShoulder],
                  let rightHip = recognizedPoints[.rightHip],
                  let leftHip = recognizedPoints[.leftHip],
                  let rightAnkle = recognizedPoints[.rightAnkle],
                  let rightWrist = recognizedPoints[.rightWrist],
                  rightShoulder.confidence > 0.7,
                  leftShoulder.confidence > 0.7,
                  rightHip.confidence > 0.7,
                  leftHip.confidence > 0.7,
                  rightAnkle.confidence > 0.7,
                  rightWrist.confidence > 0.7 else {
                print("Failed to get required body points with sufficient confidence")
                Task { @MainActor in
                    self.processingImage = false
                }
                return
            }
            
            // Convert normalized points to image coordinates
            let rightShoulderPoint = convertPoint(rightShoulder)
            let leftShoulderPoint = convertPoint(leftShoulder)
            let rightHipPoint = convertPoint(rightHip)
            let leftHipPoint = convertPoint(leftHip)
            let rightAnklePoint = convertPoint(rightAnkle)
            let rightWristPoint = convertPoint(rightWrist)
            
            // Calculate measurements
            let shoulderWidth = distance(from: rightShoulderPoint, to: leftShoulderPoint)
            let hipWidth = distance(from: rightHipPoint, to: leftHipPoint)
            let armLength = distance(from: rightShoulderPoint, to: rightWristPoint)
            let inseam = distance(from: rightHipPoint, to: rightAnklePoint)
            
            // Convert pixel measurements to real-world measurements using known distance
            let pixelToMeterRatio = knownDistance / Double(imageSize.width)
            
            let measurements = BodyMeasurements(
                chest: shoulderWidth * pixelToMeterRatio * 100,
                waist: hipWidth * pixelToMeterRatio * 100,
                armLength: armLength * pixelToMeterRatio * 100,
                inseam: inseam * pixelToMeterRatio * 100
            )
            
            Task { @MainActor in
                self.measurements = measurements
                self.processingImage = false
            }
            
        } catch {
            print("Error processing body pose: \(error)")
            Task { @MainActor in
                self.processingImage = false
            }
        }
    }
    private func distance(from point1: CGPoint, to point2: CGPoint) -> Double {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }
}

// MARK: - Views
struct ContentView: View {
    @StateObject private var viewModel = BodyMeasurementViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingMeasurements = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Select Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                if viewModel.processingImage {
                    ProgressView("Processing...")
                }
            }
            .navigationTitle("Body Measurements")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in
                if let image = inputImage {
                    viewModel.processImage(image)
                    showingMeasurements = true
                }
            }
            .sheet(isPresented: $showingMeasurements) {
                MeasurementsView(measurements: viewModel.measurements)
            }
        }
    }
}

struct MeasurementsView: View {
    let measurements: BodyMeasurements?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if let measurements = measurements {
                List {
                    Section(header: Text("Body Measurements")) {
                        HStack {
                            Text("Chest")
                            Spacer()
                            Text(String(format: "%.1f cm", measurements.chest))
                        }
                        
                        HStack {
                            Text("Waist")
                            Spacer()
                            Text(String(format: "%.1f cm", measurements.waist))
                        }
                        
                        HStack {
                            Text("Arm Length")
                            Spacer()
                            Text(String(format: "%.1f cm", measurements.armLength))
                        }
                        
                        HStack {
                            Text("Inseam")
                            Spacer()
                            Text(String(format: "%.1f cm", measurements.inseam))
                        }
                    }
                    
                    Section(header: Text("Recommended Size")) {
                        HStack {
                            Text("Size")
                            Spacer()
                            Text(measurements.size)
                                .bold()
                        }
                    }
                }
                .navigationTitle("Results")
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
            } else {
                Text("No measurements available")
            }
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
