//
//  AppStorageService.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/18.
//

import Foundation
import SwiftUI

// AppStorageService provides a SwiftUI-friendly storage solution using @AppStorage for simple values
/// and UserDefaults for complex data with automatic UI updates
@MainActor
class AppStorageService: ObservableObject {
    
    // MARK: - App Settings (using @AppStorage)
    @AppStorage("temperatureUnit") var temperatureUnit: String = "celsius"
    @AppStorage("lastLocationUpdate") var lastLocationUpdate: Double = 0
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("cacheExpirationHours") var cacheExpirationHours: Double = 24
    @AppStorage("enableNotifications") var enableNotifications: Bool = true
    
    // MARK: - Complex Data Storage (using UserDefaults with ObservableObject)
    private let favouritesKey = "favouriteLocations"
    private let cacheKey = "cachedWeatherData"
    
    @Published var favourites: [FavouriteLocation] = []
    @Published var cachedWeather: [CachedWeather] = []
    
    init() {
        loadFavourites()
        loadCachedWeather()
    }
    
    // MARK: - Favourites Management
    func loadFavourites() {
        guard let data = UserDefaults.standard.data(forKey: favouritesKey) else {
            favourites = []
            return
        }
        favourites = (try? JSONDecoder().decode([FavouriteLocation].self, from: data)) ?? []
    }
    
    func saveFavourites(_ locations: [FavouriteLocation]) {
        favourites = locations
        let data = try? JSONEncoder().encode(locations)
        UserDefaults.standard.set(data, forKey: favouritesKey)
    }
    
    func addFavourite(_ location: FavouriteLocation) {
        var updatedFavourites = favourites
        if !updatedFavourites.contains(location) {
            updatedFavourites.append(location)
            saveFavourites(updatedFavourites)
        }
    }
    
    func removeFavourite(_ location: FavouriteLocation) {
        let updatedFavourites = favourites.filter { $0 != location }
        saveFavourites(updatedFavourites)
    }
    
    // MARK: - Weather Cache Management
    func loadCachedWeather() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            cachedWeather = []
            return
        }
        cachedWeather = (try? JSONDecoder().decode([CachedWeather].self, from: data)) ?? []
    }
    
    func saveCachedWeather(_ cache: [CachedWeather]) {
        cachedWeather = cache
        let data = try? JSONEncoder().encode(cache)
        UserDefaults.standard.set(data, forKey: cacheKey)
    }
    
    func getCachedWeather(for location: FavouriteLocation) -> CachedWeather? {
        return cachedWeather.first { $0.location == location }
    }
    
    func cacheWeather(for location: FavouriteLocation, weather: WeatherResponse, forecast: [ForecastItem]) {
        let cached = CachedWeather(
            location: location,
            weatherData: weather,
            forecastData: forecast,
            lastUpdated: Date()
        )
        
        // Remove existing cache for this location
        cachedWeather.removeAll { $0.location == location }
        // Add new cache
        cachedWeather.append(cached)
        
        // Clean up old cache (older than expiration time)
        let expirationDate = Date().addingTimeInterval(-cacheExpirationHours * 3600)
        cachedWeather.removeAll { $0.lastUpdated < expirationDate }
        
        saveCachedWeather(cachedWeather)
    }
    
    // MARK: - Settings Management
    func updateLastLocationUpdate() {
        lastLocationUpdate = Date().timeIntervalSince1970
    }
    
    func isCacheValid(for location: FavouriteLocation) -> Bool {
        guard let cached = getCachedWeather(for: location) else { return false }
        let expirationDate = Date().addingTimeInterval(-cacheExpirationHours * 3600)
        return cached.lastUpdated > expirationDate
    }

}

