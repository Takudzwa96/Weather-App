//
//  LocationServiceTests.swift
//  Weather AppTests
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import XCTest
@testable import Weather_App
import CoreLocation
import Combine

final class LocationServiceTests: XCTestCase {
    
    var sut: LocationService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = LocationService()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testLocationService_Initialization() {
        // Given & When
        let locationService = LocationService()
        
        // Then
        XCTAssertNotNil(locationService)
        XCTAssertEqual(locationService.authorizationStatus, .notDetermined)
        XCTAssertNil(locationService.location)
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testLocationService_ConformsToProtocol() {
        // Verify that LocationService conforms to LocationServiceProtocol
        XCTAssertTrue(sut is any LocationServiceProtocol)
    }
    
    func testLocationService_ObservableObject() {
        // Verify that LocationService is an ObservableObject
        XCTAssertTrue(sut is any ObservableObject)
    }
    
    // MARK: - Published Properties Tests
    
    func testLocationService_PublishedProperties() {
        // Test that published properties can be observed
        let locationExpectation = expectation(description: "Location published")
        let statusExpectation = expectation(description: "Status published")
        
        var receivedLocation: CLLocationCoordinate2D?
        var receivedStatus: CLAuthorizationStatus?
        
        // Subscribe to location updates
        sut.$location
            .dropFirst() // Skip initial nil value
            .sink { location in
                receivedLocation = location
                locationExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Subscribe to authorization status updates
        sut.$authorizationStatus
            .dropFirst() // Skip initial value
            .sink { status in
                receivedStatus = status
                statusExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Simulate updates (this would normally come from CLLocationManager)
        DispatchQueue.main.async {
            self.sut.location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            self.sut.authorizationStatus = .authorizedWhenInUse
        }
        
        wait(for: [locationExpectation, statusExpectation], timeout: 1.0)
        
        XCTAssertNotNil(receivedLocation)
        XCTAssertEqual(receivedStatus, .authorizedWhenInUse)
    }
    
    // MARK: - Error Handling Tests
    
    func testLocationServiceError_LocalizedDescriptions() {
        // Test all error cases have proper descriptions
        let errors: [LocationServiceError] = [
            .permissionDenied,
            .permissionRestricted,
            .locationUnavailable,
            .locationTimeout,
            .accuracyReduced,
            .serviceDisabled,
            .networkError,
            .unknown("Test error")
        ]
        
        for error in errors {
            XCTAssertFalse(error.localizedDescription.isEmpty, "Error description should not be empty for \(error)")
            XCTAssertNotNil(error.recoverySuggestion, "Recovery suggestion should be provided for \(error)")
        }
    }
    
    func testLocationServiceError_Equality() {
        // Test error equality
        XCTAssertEqual(LocationServiceError.permissionDenied, LocationServiceError.permissionDenied)
        XCTAssertEqual(LocationServiceError.unknown("test"), LocationServiceError.unknown("test"))
        XCTAssertNotEqual(LocationServiceError.unknown("test1"), LocationServiceError.unknown("test2"))
        XCTAssertNotEqual(LocationServiceError.permissionDenied, LocationServiceError.permissionRestricted)
    }
    
    // MARK: - Mock Integration Tests
    
    func testMockLocationService_Integration() async throws {
        // Test integration with mock service
        let mockService = MockLocationService()
        let testLocation = MockLocationService.sanFrancisco
        
        // Configure mock
        mockService.configureLocation(testLocation)
        mockService.configureAuthorizationStatus(.authorizedWhenInUse)
        
        // Test permission request
        let status = await mockService.requestLocationPermission()
        XCTAssertEqual(status, .authorizedWhenInUse)
        XCTAssertEqual(mockService.requestPermissionCallCount, 1)
        
        // Test location request
        let location = try await mockService.getCurrentLocation()
        XCTAssertNotNil(location)
        XCTAssertEqual(location?.latitude, testLocation.latitude)
        XCTAssertEqual(location?.longitude, testLocation.longitude)
        XCTAssertEqual(mockService.getCurrentLocationCallCount, 1)
    }
    
    func testMockLocationService_ErrorHandling() async {
        // Test mock error handling
        let mockService = MockLocationService()
        mockService.configureError(.permissionDenied)
        
        do {
            _ = try await mockService.getCurrentLocation()
            XCTFail("Should have thrown an error")
        } catch let error as LocationServiceError {
            XCTAssertEqual(error, .permissionDenied)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testMockLocationService_LocationUpdates() {
        // Test mock location updates
        let mockService = MockLocationService()
        let testLocation = MockLocationService.newYork
        
        let expectation = expectation(description: "Location updated")
        var receivedLocation: CLLocationCoordinate2D?
        
        mockService.$location
            .dropFirst() // Skip initial nil
            .sink { location in
                receivedLocation = location
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Simulate location update
        mockService.simulateLocationUpdate(testLocation)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(receivedLocation)
        XCTAssertEqual(receivedLocation?.latitude, testLocation.latitude)
        XCTAssertEqual(receivedLocation?.longitude, testLocation.longitude)
    }
    
    func testMockLocationService_AuthorizationUpdates() {
        // Test mock authorization updates
        let mockService = MockLocationService()
        
        let expectation = expectation(description: "Authorization updated")
        var receivedStatus: CLAuthorizationStatus?
        
        mockService.$authorizationStatus
            .dropFirst() // Skip initial value
            .sink { status in
                receivedStatus = status
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Simulate authorization change
        mockService.simulateAuthorizationChange(.authorizedAlways)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedStatus, .authorizedAlways)
    }
    
    func testMockLocationService_StartStopUpdates() {
        // Test mock start/stop location updates
        let mockService = MockLocationService()
        let testLocation = MockLocationService.london
        
        mockService.configureLocation(testLocation)
        
        // Start updates
        mockService.startLocationUpdates()
        XCTAssertEqual(mockService.startLocationUpdatesCallCount, 1)
        XCTAssertEqual(mockService.location?.latitude, testLocation.latitude)
        
        // Stop updates
        mockService.stopLocationUpdates()
        XCTAssertEqual(mockService.stopLocationUpdatesCallCount, 1)
    }
    
    func testMockLocationService_Reset() async {
        // Test mock reset functionality
        let mockService = MockLocationService()
        
        // Configure mock with some state
        mockService.configureLocation(MockLocationService.tokyo)
        mockService.configureAuthorizationStatus(.authorizedAlways)
        mockService.configureError(.locationTimeout)
        
        // Make some calls to track
        _ = await mockService.requestLocationPermission()
        mockService.startLocationUpdates()
        
        // Verify state before reset
        XCTAssertEqual(mockService.requestPermissionCallCount, 1)
        XCTAssertEqual(mockService.startLocationUpdatesCallCount, 1)
        XCTAssertNotNil(mockService.location)
        
        // Reset
        mockService.reset()
        
        // Verify state after reset
        XCTAssertEqual(mockService.requestPermissionCallCount, 0)
        XCTAssertEqual(mockService.startLocationUpdatesCallCount, 0)
        XCTAssertEqual(mockService.getCurrentLocationCallCount, 0)
        XCTAssertEqual(mockService.stopLocationUpdatesCallCount, 0)
        XCTAssertNil(mockService.location)
        XCTAssertEqual(mockService.authorizationStatus, .notDetermined)
        XCTAssertFalse(mockService.shouldReturnError)
    }
    
    // MARK: - Predefined Locations Tests
    
    func testMockLocationService_PredefinedLocations() {
        // Test predefined test locations
        let sanFrancisco = MockLocationService.sanFrancisco
        XCTAssertEqual(sanFrancisco.latitude, 37.7749, accuracy: 0.001)
        XCTAssertEqual(sanFrancisco.longitude, -122.4194, accuracy: 0.001)
        
        let newYork = MockLocationService.newYork
        XCTAssertEqual(newYork.latitude, 40.7128, accuracy: 0.001)
        XCTAssertEqual(newYork.longitude, -74.0060, accuracy: 0.001)
        
        let london = MockLocationService.london
        XCTAssertEqual(london.latitude, 51.5074, accuracy: 0.001)
        XCTAssertEqual(london.longitude, -0.1278, accuracy: 0.001)
        
        let tokyo = MockLocationService.tokyo
        XCTAssertEqual(tokyo.latitude, 35.6762, accuracy: 0.001)
        XCTAssertEqual(tokyo.longitude, 139.6503, accuracy: 0.001)
        
        let paris = MockLocationService.paris
        XCTAssertEqual(paris.latitude, 48.8566, accuracy: 0.001)
        XCTAssertEqual(paris.longitude, 2.3522, accuracy: 0.001)
    }
}
