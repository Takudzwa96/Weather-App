//
//  MockLocationService.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/21.
//

import Foundation
import CoreLocation
import Combine

// Mock implementation of LocationServiceProtocol for testing
class MockLocationService: LocationServiceProtocol {
    
    // MARK: - Published Properties
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // MARK: - Test Configuration
    var shouldReturnError = false
    var errorToReturn: LocationServiceError = .locationUnavailable
    var locationToReturn: CLLocationCoordinate2D?
    var authorizationStatusToReturn: CLAuthorizationStatus = .authorizedWhenInUse
    var delayDuration: TimeInterval = 0.1
    
    // MARK: - Call Tracking
    private(set) var requestPermissionCallCount = 0
    private(set) var getCurrentLocationCallCount = 0
    private(set) var startLocationUpdatesCallCount = 0
    private(set) var stopLocationUpdatesCallCount = 0
    
    // MARK: - LocationServiceProtocol Implementation
    
    func requestLocationPermission() async -> CLAuthorizationStatus {
        requestPermissionCallCount += 1
        
        // Simulate permission request delay
        if delayDuration > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        authorizationStatus = authorizationStatusToReturn
        return authorizationStatus
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        getCurrentLocationCallCount += 1
        
        // Simulate location request delay
        if delayDuration > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            throw LocationServiceError.permissionDenied
        }
        
        location = locationToReturn
        return locationToReturn
    }
    
    func startLocationUpdates() {
        startLocationUpdatesCallCount += 1
        
        // Simulate starting location updates
        if let locationToReturn = locationToReturn {
            location = locationToReturn
        }
    }
    
    func stopLocationUpdates() {
        stopLocationUpdatesCallCount += 1
        
        // Simulate stopping location updates
        // In a real implementation, this would stop the location manager
    }
    
    // MARK: - Test Helpers
    
    /// Resets all call tracking and configuration
    func reset() {
        shouldReturnError = false
        errorToReturn = .locationUnavailable
        locationToReturn = nil
        authorizationStatusToReturn = .authorizedWhenInUse
        delayDuration = 0.1
        requestPermissionCallCount = 0
        getCurrentLocationCallCount = 0
        startLocationUpdatesCallCount = 0
        stopLocationUpdatesCallCount = 0
        location = nil
        authorizationStatus = .notDetermined
    }
    
    /// Configures the mock to return a specific location
    func configureLocation(_ coordinate: CLLocationCoordinate2D) {
        locationToReturn = coordinate
        location = coordinate
    }
    
    /// Configures the mock to return a specific authorization status
    func configureAuthorizationStatus(_ status: CLAuthorizationStatus) {
        authorizationStatusToReturn = status
        authorizationStatus = status
    }
    
    /// Configures the mock to return an error for the next location request
    func configureError(_ error: LocationServiceError) {
        shouldReturnError = true
        errorToReturn = error
    }
    
    /// Simulates a location update
    func simulateLocationUpdate(_ coordinate: CLLocationCoordinate2D) {
        location = coordinate
    }
    
    /// Simulates an authorization status change
    func simulateAuthorizationChange(_ status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    // MARK: - Predefined Test Locations
    
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    static let newYork = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    static let london = CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
    static let tokyo = CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
    static let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
}
