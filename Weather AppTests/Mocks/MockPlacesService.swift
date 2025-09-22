//
//  MockPlacesService.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/21.
//

import Foundation

// Mock implementation of PlacesServiceProtocol for testing
class MockPlacesService: PlacesServiceProtocol {
    
    // MARK: - Test Configuration
    var shouldReturnError = false
    var errorToReturn: PlacesServiceError = .networkError("Mock error")
    var placesToReturn: [PlaceResult] = []
    var delayDuration: TimeInterval = 0.1
    
    // MARK: - Call Tracking
    private(set) var searchCallCount = 0
    private(set) var lastSearchQuery: String?
    private(set) var completionCallCount = 0
    private(set) var lastCompletionQuery: String?
    
    // MARK: - PlacesServiceProtocol Implementation
    
    func searchPlaces(query: String) async throws -> [PlaceResult] {
        searchCallCount += 1
        lastSearchQuery = query
        
        // Simulate network delay
        if delayDuration > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        // Filter places based on query if configured
        if !placesToReturn.isEmpty {
            let filteredPlaces = placesToReturn.filter { place in
                place.name.localizedCaseInsensitiveContains(query)
            }
            return filteredPlaces
        }
        
        return placesToReturn
    }
    
    func searchPlaces(query: String, completion: @escaping ([PlaceResult]) -> Void) {
        completionCallCount += 1
        lastCompletionQuery = query
        
        Task {
            do {
                let results = try await searchPlaces(query: query)
                await MainActor.run {
                    completion(results)
                }
            } catch {
                await MainActor.run {
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Test Helpers
    
    /// Resets all call tracking and configuration
    func reset() {
        shouldReturnError = false
        errorToReturn = .networkError("Mock error")
        placesToReturn = []
        delayDuration = 0.1
        searchCallCount = 0
        lastSearchQuery = nil
        completionCallCount = 0
        lastCompletionQuery = nil
    }
    
    /// Creates mock place results for testing
    static func createMockPlaces() -> [PlaceResult] {
        return [
            PlaceResult(
                name: "San Francisco",
                latitude: 37.7749,
                longitude: -122.4194,
                placeId: "ChIJIQBpAG2ahYAR_6128GcTUEo"
            ),
            PlaceResult(
                name: "New York",
                latitude: 40.7128,
                longitude: -74.0060,
                placeId: "ChIJOwg_06VPwokRYv534QaPC8g"
            ),
            PlaceResult(
                name: "London",
                latitude: 51.5074,
                longitude: -0.1278,
                placeId: "ChIJdd4hrwug2EcRmSrV3Vo6llI"
            ),
            PlaceResult(
                name: "Tokyo",
                latitude: 35.6762,
                longitude: 139.6503,
                placeId: "ChIJ51cu8IcbXWARiRtXIothAS4"
            ),
            PlaceResult(
                name: "Paris",
                latitude: 48.8566,
                longitude: 2.3522,
                placeId: "ChIJD7fiBh9u5kcRYJSMaMOCCwQ"
            )
        ]
    }
    
    /// Configures the mock to return specific places for a query
    func configurePlacesForQuery(_ query: String, places: [PlaceResult]) {
        placesToReturn = places
    }
    
    /// Configures the mock to return an error for the next request
    func configureError(_ error: PlacesServiceError) {
        shouldReturnError = true
        errorToReturn = error
    }
}
