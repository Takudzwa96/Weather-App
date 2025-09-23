//
//  MockWeatherService.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/21.
//

import Foundation
import CoreLocation

/// Mock implementation of WeatherServiceProtocol for testing
class MockWeatherService: WeatherServiceProtocol {
    
    // MARK: - Test Configuration
    var shouldReturnError = false
    var errorToReturn: WeatherServiceError = .networkError("Mock error")
    var currentWeatherToReturn: WeatherResponse?
    var forecastToReturn: ForecastResponse?
    var delayDuration: TimeInterval = 0.1
    
    // MARK: - Call Tracking
    private(set) var fetchCurrentWeatherCallCount = 0
    private(set) var fetchForecastCallCount = 0
    private(set) var lastCurrentWeatherCoordinates: (lat: Double, lon: Double)?
    private(set) var lastForecastCoordinates: (lat: Double, lon: Double)?
    
    // MARK: - WeatherServiceProtocol Implementation
    
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        fetchCurrentWeatherCallCount += 1
        lastCurrentWeatherCoordinates = (lat: lat, lon: lon)
        
        // Simulate network delay
        if delayDuration > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        guard let weather = currentWeatherToReturn else {
            throw WeatherServiceError.invalidResponse
        }
        
        return weather
    }
    
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResponse {
        fetchForecastCallCount += 1
        lastForecastCoordinates = (lat: lat, lon: lon)
        
        // Simulate network delay
        if delayDuration > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
        
        if shouldReturnError {
            throw errorToReturn
        }
        
        guard let forecast = forecastToReturn else {
            throw WeatherServiceError.invalidResponse
        }
        
        return forecast
    }
    
    // MARK: - Test Helpers
    
    /// Resets all call tracking and configuration
    func reset() {
        shouldReturnError = false
        errorToReturn = .networkError("Mock error")
        currentWeatherToReturn = nil
        forecastToReturn = nil
        delayDuration = 0.1
        fetchCurrentWeatherCallCount = 0
        fetchForecastCallCount = 0
        lastCurrentWeatherCoordinates = nil
        lastForecastCoordinates = nil
    }
    
    /// Creates a mock weather response for testing
    static func createMockWeatherResponse(
        temperature: Double = 25.0,
        description: String = "Clear sky",
        cityName: String = "Test City"
    ) -> WeatherResponse {
        return WeatherResponse(
            weather: [WeatherCondition(
                main: "Clear",
                description: description
            )],
            main: MainWeather(
                temp: temperature,
                temp_min: temperature - 5,
                temp_max: temperature + 5
            ),
            name: cityName
        )
    }
    
    /// Creates a mock forecast response for testing
    static func createMockForecastResponse(days: Int = 5) -> ForecastResponse {
        let baseTime = Date().timeIntervalSince1970
        let items = (0..<days * 8).map { index in // 8 forecasts per day (3-hour intervals)
            ForecastItem(
                dt: baseTime + Double(index * 3600 * 3), // 3-hour intervals
                main: MainWeather(
                    temp: Double.random(in: 15...30),
                    temp_min: Double.random(in: 10...25),
                    temp_max: Double.random(in: 20...35)
                ),
                weather: [WeatherCondition(
                    main: "Clear",
                    description: "Clear sky"
                )],
                pop: Double.random(in: 0...1) // Random precipitation probability
            )
        }
        
        return ForecastResponse(
            list: items
        )
    }
}
