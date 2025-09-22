import Foundation

/// WeatherCacheService handles caching and retrieving weather and forecast data for offline support using UserDefaults.
class WeatherCacheService: WeatherCacheStorage {
    private let key = "cachedWeatherData" // UserDefaults key for cached weather
    
    /// Loads the entire weather cache from UserDefaults
    func loadCache() -> [CachedWeather] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([CachedWeather].self, from: data)) ?? []
    }
    
    /// Saves the entire weather cache to UserDefaults
    func saveCache(_ cache: [CachedWeather]) {
        let data = try? JSONEncoder().encode(cache)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /// Adds or updates a cached weather entry for a location
    func cacheWeather(_ cached: CachedWeather) {
        var cache = loadCache()
        cache.removeAll { $0.location == cached.location }
        cache.append(cached)
        saveCache(cache)
    }
    
    /// Retrieves cached weather for a specific location, if available
    func getCachedWeather(for location: FavouriteLocation) -> CachedWeather? {
        return loadCache().first { $0.location == location }
    }
} 
