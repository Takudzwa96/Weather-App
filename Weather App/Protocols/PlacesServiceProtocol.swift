//
//  PlacesServiceProtocol.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import Foundation

/// Protocol defining the interface for places search services
protocol PlacesServiceProtocol {
    /// Searches for places matching the query string
    /// - Parameter query: Search query string
    /// - Returns: Array of place results
    /// - Throws: PlacesServiceError for various failure scenarios
    func searchPlaces(query: String) async throws -> [PlaceResult]
    
    /// Legacy completion-based method for backward compatibility
    /// - Parameters:
    ///   - query: Search query string
    ///   - completion: Completion handler with results
    func searchPlaces(query: String, completion: @escaping ([PlaceResult]) -> Void)
}

/// Errors that can occur in places services
enum PlacesServiceError: LocalizedError, Equatable {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
    case networkError(String)
    case timeout
    case rateLimitExceeded
    case unauthorized
    case invalidQuery
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Google Places API key is missing."
        case .invalidURL:
            return "Invalid URL for places request."
        case .invalidResponse:
            return "Invalid response from places service."
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let description):
            return "Failed to decode places data: \(description)"
        case .networkError(let description):
            return "Network error: \(description)"
        case .timeout:
            return "Request timed out. Please try again."
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .unauthorized:
            return "Unauthorized access. Please check your API key."
        case .invalidQuery:
            return "Invalid search query provided."
        case .noResults:
            return "No places found for the given query."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .missingAPIKey, .unauthorized:
            return "Please check your Google Places API key configuration."
        case .timeout, .networkError:
            return "Check your internet connection and try again."
        case .rateLimitExceeded:
            return "Wait a moment before making another request."
        case .invalidQuery:
            return "Please enter a valid search query."
        case .noResults:
            return "Try a different search term or location."
        default:
            return "Please try again later."
        }
    }
}
