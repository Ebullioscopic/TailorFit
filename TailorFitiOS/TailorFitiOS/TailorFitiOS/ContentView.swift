//
//  ContentView.swift
//  TailorFitiOS
//
//  Created by admin63 on 27/09/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showCamera = false
    @State private var showingShareSheet = false
    @State private var capturedImage: UIImage?
    @State private var measurements: Measurements?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MeasureTab(showCamera: $showCamera,
                      capturedImage: $capturedImage,
                      measurements: $measurements,
                      showingShareSheet: $showingShareSheet)
                .tabItem {
                    Image(systemName: "ruler")
                    Text("Measure")
                }
                .tag(0)
            
            VirtualTryOnTab()
                .tabItem {
                    Image(systemName: "tshirt")
                    Text("Virtual Try On")
                }
                .tag(1)
        }
    }
}

struct MeasureTab: View {
    @Binding var showCamera: Bool
    @Binding var capturedImage: UIImage?
    @Binding var measurements: Measurements?
    @Binding var showingShareSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    if let measurements = measurements {
                        MeasurementsView(measurements: measurements)
                    }
                    
                    HStack(spacing: 20) {
                        Button("Update") {
                            showCamera = true
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Share") {
                            showingShareSheet = true
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    VStack {
                        Image(systemName: "camera")
                            .font(.system(size: 60))
                            .padding()
                        
                        Text("Take a photo to get started")
                            .font(.headline)
                        
                        Button("Start Scan") {
                            showCamera = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
            }
            .navigationTitle("Body Measurements")
            .sheet(isPresented: $showCamera) {
                CameraView(image: $capturedImage, measurements: $measurements)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let measurements = measurements {
                    ShareSheet(items: [measurements.toShareString()])
                }
            }
        }
    }
}

struct VirtualTryOnTab: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    HStack(spacing: 20) {
                        Button("Regenerate") {
                            // Add regeneration logic
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Share") {
                            showingShareSheet = true
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .padding()
                        
                        Text("Upload or capture an image")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Button("Upload") {
                                showImagePicker = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Capture") {
                                showImagePicker = true
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Virtual Try On")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let image = selectedImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }
}

// Supporting Views and Models

struct CameraView: View {
    @Binding var image: UIImage?
    @Binding var measurements: Measurements?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // Implement camera functionality
        Text("Camera View")
    }
}

struct ImagePicker: View {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // Implement image picker functionality
        Text("Image Picker View")
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct MeasurementsView: View {
    let measurements: Measurements
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chest: \(measurements.chest)cm")
            Text("Waist: \(measurements.waist)cm")
            Text("Hips: \(measurements.hips)cm")
            Text("Inseam: \(measurements.inseam)cm")
        }
        .padding()
    }
}

struct Measurements {
    var chest: Double
    var waist: Double
    var hips: Double
    var inseam: Double
    
    func toShareString() -> String {
        """
        TailorFit Measurements:
        Chest: \(chest)cm
        Waist: \(waist)cm
        Hips: \(hips)cm
        Inseam: \(inseam)cm
        """
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
