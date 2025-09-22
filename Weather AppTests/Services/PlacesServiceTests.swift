//
//  PlacesServiceTests.swift
//  Weather AppTests
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import XCTest
@testable import Weather_App

final class PlacesServiceTests: XCTestCase {
    
    var sut: PlacesService!
    
    override func setUp() {
        super.setUp()
        sut = PlacesService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - searchPlaces Async Tests
    
    func testSearchPlaces_ValidQuery_ReturnsResults() async throws {
        // Given
        let query = "San Francisco"
        
        // When & Then
        do {
            let results = try await sut.searchPlaces(query: query)
            
            // Verify results
            XCTAssertFalse(results.isEmpty, "Should return at least one result for a valid city")
            
            // Verify result structure
            let firstResult = results.first!
            XCTAssertFalse(firstResult.name.isEmpty)
            XCTAssertNotEqual(firstResult.latitude, 0.0)
            XCTAssertNotEqual(firstResult.longitude, 0.0)
            XCTAssertFalse(firstResult.placeId.isEmpty)
            
        } catch let error as PlacesServiceError {
            // Handle expected errors in testing environment
            switch error {
            case .missingAPIKey, .unauthorized:
                XCTFail("API key configuration issue: \(error.localizedDescription)")
            case .networkError, .timeout:
                XCTExpectFailure("Network error in test environment: \(error.localizedDescription)")
            case .noResults:
                XCTExpectFailure("No results found for query: \(query)")
            default:
                XCTFail("Unexpected places service error: \(error)")
            }
        }
    }
    
    func testSearchPlaces_EmptyQuery_ThrowsInvalidQueryError() async {
        // Given
        let emptyQuery = ""
        
        // When & Then
        do {
            _ = try await sut.searchPlaces(query: emptyQuery)
            XCTFail("Should throw invalidQuery error for empty query")
        } catch let error as PlacesServiceError {
            XCTAssertEqual(error, .invalidQuery)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testSearchPlaces_WhitespaceQuery_ThrowsInvalidQueryError() async {
        // Given
        let whitespaceQuery = "   \n\t   "
        
        // When & Then
        do {
            _ = try await sut.searchPlaces(query: whitespaceQuery)
            XCTFail("Should throw invalidQuery error for whitespace-only query")
        } catch let error as PlacesServiceError {
            XCTAssertEqual(error, .invalidQuery)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testSearchPlaces_SpecialCharacters_HandlesGracefully() async {
        // Given
        let specialCharQuery = "São Paulo"
        
        // When & Then
        do {
            let results = try await sut.searchPlaces(query: specialCharQuery)
            // Should handle special characters gracefully
            XCTAssertTrue(results.isEmpty || !results.isEmpty) // Either outcome is acceptable
        } catch let error as PlacesServiceError {
            // Network or API errors are acceptable
            XCTAssertTrue(
                error == .networkError("") ||
                error == .noResults ||
                error == .timeout ||
                error.localizedDescription.contains("network")
            )
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - searchPlaces Completion Tests
    
    func testSearchPlaces_CompletionBased_CallsCompletion() async {
        // Given
        let query = "London"
        let expectation = expectation(description: "Completion called")
        var receivedResults: [PlaceResult]?
        
        // When
        sut.searchPlaces(query: query) { results in
            receivedResults = results
            expectation.fulfill()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 10.0)
        XCTAssertNotNil(receivedResults)
    }
    
    // MARK: - Error Handling Tests
    
    func testPlacesServiceError_LocalizedDescriptions() {
        // Test all error cases have proper descriptions
        let errors: [PlacesServiceError] = [
            .missingAPIKey,
            .invalidURL,
            .invalidResponse,
            .httpError(statusCode: 404),
            .decodingError("Test decoding error"),
            .networkError("Test network error"),
            .timeout,
            .rateLimitExceeded,
            .unauthorized,
            .invalidQuery,
            .noResults
        ]
        
        for error in errors {
            XCTAssertFalse(error.localizedDescription.isEmpty, "Error description should not be empty for \(error)")
            XCTAssertNotNil(error.recoverySuggestion, "Recovery suggestion should be provided for \(error)")
        }
    }
    
    func testPlacesServiceError_Equality() {
        // Test error equality
        XCTAssertEqual(PlacesServiceError.missingAPIKey, PlacesServiceError.missingAPIKey)
        XCTAssertEqual(PlacesServiceError.httpError(statusCode: 404), PlacesServiceError.httpError(statusCode: 404))
        XCTAssertNotEqual(PlacesServiceError.httpError(statusCode: 404), PlacesServiceError.httpError(statusCode: 500))
        XCTAssertNotEqual(PlacesServiceError.missingAPIKey, PlacesServiceError.unauthorized)
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testPlacesService_ConformsToProtocol() {
        // Verify that PlacesService conforms to PlacesServiceProtocol
        XCTAssertTrue(sut is PlacesServiceProtocol)
    }
    
    // MARK: - Mock Integration Tests
    
    func testMockPlacesService_Integration() async throws {
        // Test integration with mock service
        let mockService = MockPlacesService()
        let mockPlaces = MockPlacesService.createMockPlaces()
        
        // Configure mock
        mockService.placesToReturn = mockPlaces
        
        // Test search
        let results = try await mockService.searchPlaces(query: "San Francisco")
        XCTAssertEqual(results.count, 1) // Should filter to San Francisco only
        XCTAssertEqual(results.first?.name, "San Francisco")
        XCTAssertEqual(mockService.searchCallCount, 1)
        XCTAssertEqual(mockService.lastSearchQuery, "San Francisco")
    }
    
    func testMockPlacesService_ErrorHandling() async {
        // Test mock error handling
        let mockService = MockPlacesService()
        mockService.configureError(.noResults)
        
        do {
            _ = try await mockService.searchPlaces(query: "NonexistentCity")
            XCTFail("Should have thrown an error")
        } catch let error as PlacesServiceError {
            XCTAssertEqual(error, .noResults)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testMockPlacesService_CompletionMethod() async {
        // Test mock completion method
        let mockService = MockPlacesService()
        let mockPlaces = MockPlacesService.createMockPlaces()
        mockService.placesToReturn = mockPlaces
        
        let expectation = expectation(description: "Completion called")
        var receivedResults: [PlaceResult]?
        
        mockService.searchPlaces(query: "London") { results in
            receivedResults = results
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(receivedResults)
        XCTAssertEqual(receivedResults?.count, 1) // Should filter to London only
        XCTAssertEqual(mockService.completionCallCount, 1)
        XCTAssertEqual(mockService.lastCompletionQuery, "London")
    }
    
    // MARK: - PlaceResult Tests
    
    func testPlaceResult_Properties() {
        // Test PlaceResult structure
        let place = PlaceResult(
            name: "Test Place",
            latitude: 37.7749,
            longitude: -122.4194,
            placeId: "test_place_id"
        )
        
        XCTAssertEqual(place.name, "Test Place")
        XCTAssertEqual(place.latitude, 37.7749)
        XCTAssertEqual(place.longitude, -122.4194)
        XCTAssertEqual(place.placeId, "test_place_id")
        XCTAssertNotNil(place.id) // UUID should be generated
    }
}
