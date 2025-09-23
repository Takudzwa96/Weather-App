//
//  AppConfiguration.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/18.
//

import Foundation

// Secure configuration management for the app
/// This structure provides a secure way to manage API keys and configuration
struct AppConfiguration {
    enum ConfigurationError: LocalizedError {
        case missingKey(String)
        case invalidConfiguration
        
        var errorDescription: String? {
            switch self {
            case .missingKey(let key):
                return "Missing required configuration: \(key)"
            case .invalidConfiguration:
                return "Invalid configuration file"
            }
        }
    }
    
    private static let configFileName = "Config"
    private static var config: [String: Any]?
    
    /// Load configuration from Config.plist (not tracked in git)
    private static func loadConfiguration() throws -> [String: Any] {
        if let existingConfig = config {
            return existingConfig
        }
        
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            throw ConfigurationError.invalidConfiguration
        }
        
        config = plist
        return plist
    }
    
    /// Get a configuration value safely
    private static func getValue(for key: String) throws -> String {
        let configuration = try loadConfiguration()
        guard let value = configuration[key] as? String, !value.isEmpty else {
            throw ConfigurationError.missingKey(key)
        }
        return value
    }
    
    /// OpenWeather API Key
    static var openWeatherAPIKey: String {
        do {
            return try getValue(for: "OpenWeatherAPIKey")
        } catch {
            #if DEBUG
            // For development, you can use a placeholder or environment variable
            print("⚠️ Warning: \(error.localizedDescription)")
            return ProcessInfo.processInfo.environment["OPENWEATHER_API_KEY"] ?? ""
            #else
            fatalError("Configuration error: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// Google Places API Key
    static var googlePlacesAPIKey: String {
        do {
            return try getValue(for: "GooglePlacesAPIKey")
        } catch {
            #if DEBUG
            print("⚠️ Warning: \(error.localizedDescription)")
            return ProcessInfo.processInfo.environment["GOOGLE_PLACES_API_KEY"] ?? ""
            #else
            fatalError("Configuration error: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// Validate that all required configuration is present
    static func validate() throws {
        _ = try getValue(for: "OpenWeatherAPIKey")
        _ = try getValue(for: "GooglePlacesAPIKey")
    }
}

// MARK: - Security Best Practices
extension AppConfiguration {
    /// Clear sensitive data from memory when app goes to background
    static func clearSensitiveData() {
        config = nil
    }
    
    /// Obfuscated string builder for additional protection
    private static func deobfuscate(_ obfuscated: [UInt8]) -> String {
        String(bytes: obfuscated.map { $0 ^ 0xAA }, encoding: .utf8) ?? ""
    }
}
