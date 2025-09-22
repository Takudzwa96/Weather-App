//
//  TemperatureUtils.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import Foundation

// TemperatureUtils provides temperature conversion and formatting utilities
struct TemperatureUtils {
    
    /// Converts temperature from Celsius to the specified unit
    static func convert(_ celsius: Double, to unit: TemperatureUnit) -> Double {
        switch unit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return (celsius * 9/5) + 32
        case .kelvin:
            return celsius + 273.15
        }
    }
    
    /// Formats temperature with the appropriate unit symbol
    static func format(_ celsius: Double, unit: TemperatureUnit) -> String {
        let convertedTemp = convert(celsius, to: unit)
        let roundedTemp = Int(convertedTemp.rounded())
        return "\(roundedTemp)\(unit.symbol)"
    }
    
    /// Formats temperature without the degree symbol (for display in larger text)
    static func formatWithoutSymbol(_ celsius: Double, unit: TemperatureUnit) -> String {
        let convertedTemp = convert(celsius, to: unit)
        let roundedTemp = Int(convertedTemp.rounded())
        return "\(roundedTemp)"
    }
    
    /// Gets the current temperature unit from AppStorage
    static func currentUnit() -> TemperatureUnit {
        let unitString = UserDefaults.standard.string(forKey: "temperatureUnit") ?? "celsius"
        return TemperatureUnit(rawValue: unitString) ?? .celsius
    }
}

/// TemperatureUnit enum for different temperature scales
enum TemperatureUnit: String, CaseIterable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
    case kelvin = "kelvin"
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        case .kelvin: return "K"
        }
    }
    
    var shortSymbol: String {
        switch self {
        case .celsius: return "°"
        case .fahrenheit: return "°"
        case .kelvin: return "K"
        }
    }
}
