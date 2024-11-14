//
//  Model.swift
//  TailorFitiOS
//
//  Created by admin63 on 28/10/24.
//

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
