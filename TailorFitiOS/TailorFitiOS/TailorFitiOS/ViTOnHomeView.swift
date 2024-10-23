//
//  ViTOnHomeView.swift
//  TailorFitiOS
//
//  Created by admin63 on 23/10/24.
//

import SwiftUI

struct VirtualTryOnView: View {
    @State private var selectedPhotoIndex: Int = 1
    @State private var selectedApparelIndex: Int = 1
    
    let photos = [
        "photo1", "photo2", "photo3" // Replace with actual image names
    ]
    
    let apparels = [
        "apparel1", "apparel2", "apparel3" // Replace with actual image names
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Photos Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Choose a Photo")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(0..<photos.count, id: \.self) { index in
                                PhotoCard(
                                    imageName: photos[index],
                                    isSelected: index == selectedPhotoIndex
                                )
                                .onTapGesture {
                                    selectedPhotoIndex = index
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Apparel Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Choose/Upload Apparel")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(0..<apparels.count, id: \.self) { index in
                                ApparelCard(
                                    imageName: apparels[index],
                                    isSelected: index == selectedApparelIndex
                                )
                                .onTapGesture {
                                    selectedApparelIndex = index
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Generate Button
                Button(action: {
                    // Handle generate action
                }) {
                    Text("Generate")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Tab Bar
                CustomTabBar()
            }
            .navigationBarHidden(true)
        }
    }
}

struct PhotoCard: View {
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                )
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .background(Circle().fill(Color.white))
                    .padding(8)
            }
        }
    }
}

struct ApparelCard: View {
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                )
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .background(Circle().fill(Color.white))
                    .padding(8)
            }
        }
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "figure.stand", text: "Measure")
            TabBarItem(icon: "tshirt.fill", text: "Virtual Try On", isSelected: true)
            TabBarItem(icon: "gearshape", text: "Settings")
        }
        .padding(.top, 8)
        .background(Color(UIColor.systemBackground))
    }
}

struct TabBarItem: View {
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .blue : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct VirtualTryOnView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualTryOnView()
    }
}
