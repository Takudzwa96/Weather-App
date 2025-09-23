//
//  LocationServiceProtocol.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import Foundation
import CoreLocation
import Combine

/// Protocol defining the interface for location services
protocol LocationServiceProtocol: ObservableObject {
    /// Current location coordinates
    var location: CLLocationCoordinate2D? { get }
    
    /// Current authorization status
    var authorizationStatus: CLAuthorizationStatus { get }
    
    /// Requests location permission asynchronously
    /// - Returns: Authorization status after request
    func requestLocationPermission() async -> CLAuthorizationStatus
    
    /// Gets the current location asynchronously
    /// - Returns: Current location coordinates or nil if unavailable
    /// - Throws: LocationServiceError for various failure scenarios
    func getCurrentLocation() async throws -> CLLocationCoordinate2D?
    
    /// Starts continuous location updates
    func startLocationUpdates()
    
    /// Stops continuous location updates
    func stopLocationUpdates()
}

/// Errors that can occur in location services
enum LocationServiceError: LocalizedError, Equatable {
    case permissionDenied
    case permissionRestricted
    case locationUnavailable
    case locationTimeout
    case accuracyReduced
    case serviceDisabled
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable location access in Settings."
        case .permissionRestricted:
            return "Location access is restricted on this device."
        case .locationUnavailable:
            return "Location is currently unavailable."
        case .locationTimeout:
            return "Location request timed out."
        case .accuracyReduced:
            return "Location accuracy is reduced due to system settings."
        case .serviceDisabled:
            return "Location services are disabled. Please enable them in Settings."
        case .networkError:
            return "Network error while getting location."
        case .unknown(let description):
            return "Unknown location error: \(description)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied, .permissionRestricted, .serviceDisabled:
            return "Please check location permissions in Settings."
        case .locationTimeout, .locationUnavailable:
            return "Try again or move to an area with better signal."
        case .accuracyReduced:
            return "Check location accuracy settings in Privacy & Security."
        case .networkError:
            return "Check your internet connection."
        case .unknown:
            return "Please try again later."
        }
    }
}
