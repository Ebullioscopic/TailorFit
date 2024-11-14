//
//  Model.swift
//  TailorFitiOS
//
//  Created by hariharan on 24/10/24.
//

import Foundation

// MARK: - Enums

enum Gender: String, Codable {
    case male
    case female
    case unisex
}

enum SizeRegion: String, Codable {
    case us
    case uk
    case eu
    case asia // Japan, China, Korea
    case international // ISO
    case australia
}

enum MeasurementUnit: String, Codable {
    case inches
    case centimeters
    
    func convert(_ value: Double, to unit: MeasurementUnit) -> Double {
        switch (self, unit) {
        case (.inches, .centimeters):
            return value * 2.54
        case (.centimeters, .inches):
            return value / 2.54
        default:
            return value
        }
    }
}

enum ClothingCategory: String, Codable {
    case tops
    case bottoms
    case dresses
    case outerwear
    case suits
}

enum FitType: String, Codable {
    case slim
    case regular
    case relaxed
    case loose
}

// MARK: - Main Models

struct BodyMeasurements: Codable, Identifiable {
    let id: UUID
    let timestamp: Date
    let gender: Gender
    let unit: MeasurementUnit
    
    // Basic measurements
    let height: Double
    let weight: Double
    
    // Upper body measurements
    let neck: Double
    let chest: Double
    let bust: Double? // For women's measurements
    let waist: Double
    let hips: Double
    let shoulder: Double
    let armLength: Double
    let bicep: Double
    let forearm: Double
    let wrist: Double
    
    // Lower body measurements
    let inseam: Double
    let outseam: Double
    let thigh: Double
    let knee: Double
    let calf: Double
    let ankle: Double
    
    // Additional measurements
    let torsoLength: Double
    let shoulderToWaist: Double
    let waistToHip: Double
    let waistToKnee: Double
    let waistToAnkle: Double
    
    // Calculated properties
    var bmi: Double {
        let heightInMeters = unit == .inches ? height * 0.0254 : height / 100
        let weightInKg = unit == .inches ? weight * 0.453592 : weight
        return weightInKg / (heightInMeters * heightInMeters)
    }
}

struct SizeRecommendation: Codable {
    let measurements: BodyMeasurements
    let recommendations: [ClothingCategory: [BrandSizing]]
}

struct BrandSizing: Codable {
    let brand: ClothingBrand
    let category: ClothingCategory
    let recommendedSize: String
    let fitType: FitType
    let confidence: Double // 0.0 to 1.0
}

struct ClothingBrand: Codable, Identifiable {
    let id: UUID
    let name: String
    let region: SizeRegion
    let sizingCharts: [ClothingCategory: SizingChart]
}

struct SizingChart: Codable {
    let sizes: [SizeDetails]
    let measurementPoints: [String] // e.g., ["chest", "waist", "hips"]
    let fitGuide: FitGuide
}

struct SizeDetails: Codable {
    let name: String // e.g., "S", "M", "L" or "32", "34", "36"
    let measurements: [String: ClosedRange<Double>] // e.g., ["chest": 38.0...40.0]
    let equivalentSizes: [SizeRegion: String] // e.g., [.uk: "M", .eu: "50"]
}

struct FitGuide: Codable {
    let recommendedFit: FitType
    let stretchFactor: Double // 0.0 to 1.0
    let sizingNotes: String
    let careInstructions: String
}

// MARK: - Extensions

extension BodyMeasurements {
    
    func convertTo(unit targetUnit: MeasurementUnit) -> BodyMeasurements {
        guard unit != targetUnit else { return self }
        
        return BodyMeasurements(
            id: id,
            timestamp: timestamp,
            gender: gender,
            unit: targetUnit,
            height: unit.convert(height, to: targetUnit),
            weight: weight, // Weight conversion handled separately
            neck: unit.convert(neck, to: targetUnit),
            chest: unit.convert(chest, to: targetUnit),
            bust: bust.map { unit.convert($0, to: targetUnit) },
            waist: unit.convert(waist, to: targetUnit),
            hips: unit.convert(hips, to: targetUnit),
            shoulder: unit.convert(shoulder, to: targetUnit),
            armLength: unit.convert(armLength, to: targetUnit),
            bicep: unit.convert(bicep, to: targetUnit),
            forearm: unit.convert(forearm, to: targetUnit),
            wrist: unit.convert(wrist, to: targetUnit),
            inseam: unit.convert(inseam, to: targetUnit),
            outseam: unit.convert(outseam, to: targetUnit),
            thigh: unit.convert(thigh, to: targetUnit),
            knee: unit.convert(knee, to: targetUnit),
            calf: unit.convert(calf, to: targetUnit),
            ankle: unit.convert(ankle, to: targetUnit),
            torsoLength: unit.convert(torsoLength, to: targetUnit),
            shoulderToWaist: unit.convert(shoulderToWaist, to: targetUnit),
            waistToHip: unit.convert(waistToHip, to: targetUnit),
            waistToKnee: unit.convert(waistToKnee, to: targetUnit),
            waistToAnkle: unit.convert(waistToAnkle, to: targetUnit)
        )
    }
    
    // Helper method to get measurements as a dictionary
    func measurementsDictionary() -> [String: Double] {
        [
            "neck": neck,
            "chest": chest,
            "bust": bust ?? 0,
            "waist": waist,
            "hips": hips,
            "shoulder": shoulder,
            "armLength": armLength,
            "bicep": bicep,
            "forearm": forearm,
            "wrist": wrist,
            "inseam": inseam,
            "outseam": outseam,
            "thigh": thigh,
            "knee": knee,
            "calf": calf,
            "ankle": ankle
        ]
    }
}

// MARK: - Size Calculator

struct SizeCalculator {
    static func calculateSize(
        measurements: BodyMeasurements,
        brand: ClothingBrand,
        category: ClothingCategory
    ) -> BrandSizing? {
        guard let sizingChart = brand.sizingCharts[category] else { return nil }
        
        // Convert measurements to brand's region standard if needed
        let convertedMeasurements = measurements.convertTo(unit: .inches) // Most brands use inches
        let measurementDict = convertedMeasurements.measurementsDictionary()
        
        var bestMatch: (size: SizeDetails, confidence: Double)? = nil
        var highestConfidence = 0.0
        
        // Check each size against measurements
        for size in sizingChart.sizes {
            var matchPoints = 0.0
            var totalPoints = 0.0
            
            for point in sizingChart.measurementPoints {
                guard let range = size.measurements[point],
                      let measurement = measurementDict[point] else { continue }
                
                totalPoints += 1.0
                
                if range.contains(measurement) {
                    matchPoints += 1.0
                } else {
                    // Calculate partial match based on distance to range
                    let distance = min(abs(measurement - range.lowerBound),
                                    abs(measurement - range.upperBound))
                    let partial = max(0, 1 - (distance / 2)) // 2 inch maximum deviation
                    matchPoints += partial
                }
            }
            
            let confidence = matchPoints / totalPoints
            if confidence > highestConfidence {
                highestConfidence = confidence
                bestMatch = (size, confidence)
            }
        }
        
        guard let match = bestMatch else { return nil }
        
        return BrandSizing(
            brand: brand,
            category: category,
            recommendedSize: match.size.name,
            fitType: sizingChart.fitGuide.recommendedFit,
            confidence: match.confidence
        )
    }
}

// MARK: - Sample Usage

extension ClothingBrand {
    static var nike: ClothingBrand {
        ClothingBrand(
            id: UUID(),
            name: "Nike",
            region: .us,
            sizingCharts: [
                .tops: SizingChart(
                    sizes: [
                        SizeDetails(
                            name: "S",
                            measurements: [
                                "chest": 35.0...37.0,
                                "waist": 29.0...31.0
                            ],
                            equivalentSizes: [
                                .uk: "S",
                                .eu: "46"
                            ]
                        ),
                        // Add more sizes...
                    ],
                    measurementPoints: ["chest", "waist"],
                    fitGuide: FitGuide(
                        recommendedFit: .regular,
                        stretchFactor: 0.2,
                        sizingNotes: "Athletic fit, if between sizes go up",
                        careInstructions: "Machine wash cold"
                    )
                )
                // Add more categories...
            ]
        )
    }
}
