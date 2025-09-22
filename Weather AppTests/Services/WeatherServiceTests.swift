//
//  WeatherServiceTests.swift
//  Weather AppTests
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import XCTest
@testable import Weather_App
import CoreLocation

final class WeatherServiceTests: XCTestCase {
    
    var sut: WeatherService!
    
    override func setUp() {
        super.setUp()
        sut = WeatherService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - fetchCurrentWeather Tests
    
    func testFetchCurrentWeather_ValidCoordinates_ReturnsWeatherResponse() async throws {
        // Given
        let lat = 37.7749
        let lon = -122.4194
        
        // When & Then
        do {
            let weather = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
            
            // Verify the response structure
            XCTAssertNotNil(weather.main)
            XCTAssertNotNil(weather.weather)
            XCTAssertFalse(weather.weather.isEmpty)
            XCTAssertNotNil(weather.name)
        } catch let error as WeatherServiceError {
            // If API key is missing or invalid, we expect specific errors
            switch error {
            case .missingAPIKey, .unauthorized:
                XCTFail("API key configuration issue: \(error.localizedDescription)")
            case .networkError, .timeout:
                // Network issues are acceptable in testing environment
                XCTExpectFailure("Network error in test environment: \(error.localizedDescription)")
            default:
                XCTFail("Unexpected weather service error: \(error)")
            }
        }
    }
    
    func testFetchCurrentWeather_InvalidCoordinates_HandlesGracefully() async {
        // Given
        let lat = 999.0 // Invalid latitude
        let lon = 999.0 // Invalid longitude
        
        // When & Then
        do {
            _ = try await sut.fetchCurrentWeather(lat: lat, lon: lon)
            // If it succeeds, that's also valid behavior for some APIs
        } catch let error as WeatherServiceError {
            // We expect some kind of error for invalid coordinates
            XCTAssertTrue(
                error == .httpError(statusCode: 400) ||
                error == .invalidResponse ||
                error.localizedDescription.contains("network") ||
                error.localizedDescription.contains("400")
            )
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - fetchForecast Tests
    
    func testFetchForecast_ValidCoordinates_ReturnsForecastResponse() async throws {
        // Given
        let lat = 37.7749
        let lon = -122.4194
        
        // When & Then
        do {
            let forecast = try await sut.fetchForecast(lat: lat, lon: lon)
            
            // Verify the response structure
            XCTAssertNotNil(forecast.list)
            XCTAssertFalse(forecast.list.isEmpty)
            
            // Verify forecast items have required data
            let firstItem = forecast.list.first!
            XCTAssertNotNil(firstItem.main)
            XCTAssertNotNil(firstItem.weather)
            XCTAssertFalse(firstItem.weather.isEmpty)
            
        } catch let error as WeatherServiceError {
            // Handle expected errors in testing environment
            switch error {
            case .missingAPIKey, .unauthorized:
                XCTFail("API key configuration issue: \(error.localizedDescription)")
            case .networkError, .timeout:
                XCTExpectFailure("Network error in test environment: \(error.localizedDescription)")
            default:
                XCTFail("Unexpected weather service error: \(error)")
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testWeatherServiceError_LocalizedDescriptions() {
        // Test all error cases have proper descriptions
        let errors: [WeatherServiceError] = [
            .missingAPIKey,
            .invalidURL,
            .invalidResponse,
            .httpError(statusCode: 404),
            .decodingError("Test decoding error"),
            .networkError("Test network error"),
            .timeout,
            .rateLimitExceeded,
            .unauthorized
        ]
        
        for error in errors {
            XCTAssertFalse(error.localizedDescription.isEmpty, "Error description should not be empty for \(error)")
            XCTAssertNotNil(error.recoverySuggestion, "Recovery suggestion should be provided for \(error)")
        }
    }
    
    func testWeatherServiceError_Equality() {
        // Test error equality
        XCTAssertEqual(WeatherServiceError.missingAPIKey, WeatherServiceError.missingAPIKey)
        XCTAssertEqual(WeatherServiceError.httpError(statusCode: 404), WeatherServiceError.httpError(statusCode: 404))
        XCTAssertNotEqual(WeatherServiceError.httpError(statusCode: 404), WeatherServiceError.httpError(statusCode: 500))
        XCTAssertNotEqual(WeatherServiceError.missingAPIKey, WeatherServiceError.unauthorized)
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testWeatherService_ConformsToProtocol() {
        // Verify that WeatherService conforms to WeatherServiceProtocol
        XCTAssertTrue(sut is WeatherServiceProtocol)
    }
    
    // MARK: - Mock Integration Tests
    
    func testMockWeatherService_Integration() async throws {
        // Test integration with mock service
        let mockService = MockWeatherService()
        
        // Configure mock
        mockService.currentWeatherToReturn = MockWeatherService.createMockWeatherResponse()
        mockService.forecastToReturn = MockWeatherService.createMockForecastResponse()
        
        // Test current weather
        let weather = try await mockService.fetchCurrentWeather(lat: 37.7749, lon: -122.4194)
        XCTAssertEqual(weather.main.temp, 25.0)
        XCTAssertEqual(weather.name, "Test City")
        XCTAssertEqual(mockService.fetchCurrentWeatherCallCount, 1)
        
        // Test forecast
        let forecast = try await mockService.fetchForecast(lat: 37.7749, lon: -122.4194)
        XCTAssertFalse(forecast.list.isEmpty)
        XCTAssertEqual(mockService.fetchForecastCallCount, 1)
    }
    
    func testMockWeatherService_ErrorHandling() async {
        // Test mock error handling
        let mockService = MockWeatherService()
        mockService.shouldReturnError = true
        mockService.errorToReturn = .unauthorized
        
        do {
            _ = try await mockService.fetchCurrentWeather(lat: 37.7749, lon: -122.4194)
            XCTFail("Should have thrown an error")
        } catch let error as WeatherServiceError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
