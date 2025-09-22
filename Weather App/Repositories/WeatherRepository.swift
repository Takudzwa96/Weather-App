import Foundation
import CoreLocation
import SwiftUI

/// WeatherRepository handles fetching, caching, and providing weather and forecast data from the API or cache.
@MainActor
class WeatherRepository: ObservableObject {
    private let weatherService: any WeatherServiceProtocol // Service for API calls
    private let appStorage: AppStorageService              // AppStorage service for reactive caching
    
    init(weatherService: any WeatherServiceProtocol, appStorage: AppStorageService) {
        self.weatherService = weatherService
        self.appStorage = appStorage
    }
    
    // MARK: - Public Interface
    /// Fetches current weather for a given location, using cache if API fails
    func getCurrentWeather(for location: CLLocationCoordinate2D) async throws -> WeatherResponse {
        do {
            // Try to fetch from API
            let weather = try await weatherService.fetchCurrentWeather(lat: location.latitude, lon: location.longitude)
            
            // Cache the successful response
            let favLocation = FavouriteLocation(name: "Current", latitude: location.latitude, longitude: location.longitude)
            await cacheWeather(for: favLocation, weather: weather, forecast: [])
            
            return weather
        } catch {
            // If API fails, try to load from cache
            let favLocation = FavouriteLocation(name: "Current", latitude: location.latitude, longitude: location.longitude)
            if let cached = appStorage.getCachedWeather(for: favLocation) {
                return cached.weatherData
            }
            throw error
        }
    }
    
    /// Fetches forecast for a given location, using cache if API fails
    func getForecast(for location: CLLocationCoordinate2D) async throws -> [ForecastItem] {
        do {
            // Try to fetch from API
            let forecast = try await weatherService.fetchForecast(lat: location.latitude, lon: location.longitude)
            
            // Cache the successful response
            let favLocation = FavouriteLocation(name: "Current", latitude: location.latitude, longitude: location.longitude)
            await cacheWeather(for: favLocation, weather: nil, forecast: forecast.list)
            
            return forecast.list
        } catch {
            // If API fails, try to load from cache
            let favLocation = FavouriteLocation(name: "Current", latitude: location.latitude, longitude: location.longitude)
            if let cached = appStorage.getCachedWeather(for: favLocation) {
                return cached.forecastData
            }
            throw error
        }
    }
    
    /// Fetches both weather and forecast for a favourite location, using cache if API fails
    func getWeatherForFavourite(_ location: FavouriteLocation) async throws -> (WeatherResponse, [ForecastItem]) {
        do {
            // Try to fetch from API
            let weather = try await weatherService.fetchCurrentWeather(lat: location.latitude, lon: location.longitude)
            let forecast = try await weatherService.fetchForecast(lat: location.latitude, lon: location.longitude)
            
            // Cache the successful response
            await cacheWeather(for: location, weather: weather, forecast: forecast.list)
            
            return (weather, forecast.list)
        } catch {
            // If API fails, try to load from cache
            if let cached = appStorage.getCachedWeather(for: location) {
                return (cached.weatherData, cached.forecastData)
            }
            throw error
        }
    }
    
    /// Returns cached weather for a favourite location, if available
    func getCachedWeather(for location: FavouriteLocation) -> CachedWeather? {
        return appStorage.getCachedWeather(for: location)
    }
    
    // MARK: - Private Methods
    /// Caches weather and forecast data for a location
    private func cacheWeather(for location: FavouriteLocation, weather: WeatherResponse?, forecast: [ForecastItem]) async {
        // Only cache if we have both weather and forecast data
        guard let weather = weather else { return }
        
        appStorage.cacheWeather(for: location, weather: weather, forecast: forecast)
    }
} 