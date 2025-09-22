//
//  WeatherServiceProtocol.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import Foundation
import CoreLocation

/// Protocol defining the interface for weather data services
protocol WeatherServiceProtocol {
    /// Fetches current weather data for the given coordinates
    /// - Parameters:
    ///   - lat: Latitude coordinate
    ///   - lon: Longitude coordinate
    /// - Returns: Current weather response
    /// - Throws: WeatherServiceError for various failure scenarios
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherResponse
    
    /// Fetches 5-day forecast data for the given coordinates
    /// - Parameters:
    ///   - lat: Latitude coordinate
    ///   - lon: Longitude coordinate
    /// - Returns: Forecast response with 5-day data
    /// - Throws: WeatherServiceError for various failure scenarios
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResponse
}

/// Errors that can occur in weather services
enum WeatherServiceError: LocalizedError, Equatable {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
    case networkError(String)
    case timeout
    case rateLimitExceeded
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key is missing. Please configure your API key."
        case .invalidURL:
            return "Invalid URL for weather request."
        case .invalidResponse:
            return "Invalid response from weather service."
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let description):
            return "Failed to decode weather data: \(description)"
        case .networkError(let description):
            return "Network error: \(description)"
        case .timeout:
            return "Request timed out. Please try again."
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .unauthorized:
            return "Unauthorized access. Please check your API key."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .missingAPIKey, .unauthorized:
            return "Please check your API key configuration."
        case .timeout, .networkError:
            return "Check your internet connection and try again."
        case .rateLimitExceeded:
            return "Wait a moment before making another request."
        default:
            return "Please try again later."
        }
    }
}
