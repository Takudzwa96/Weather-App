import Foundation
import CoreLocation

// WeatherViewModel manages the state and business logic for weather data, including current weather, forecast, loading state, and error handling.
@MainActor
class WeatherViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: [ForecastItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?
    @Published var isOffline = false

    private let weatherRepository: WeatherRepository           // Repository for weather data and caching
    private let locationService: any LocationServiceProtocol   // Location service for current location
    
    init(weatherRepository: WeatherRepository, locationService: any LocationServiceProtocol) {
        self.weatherRepository = weatherRepository
        self.locationService = locationService
    }

    // Returns one forecast item per day (closest to noon)
    var dailyForecast: [ForecastItem] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: forecast) { item in
            let date = Date(timeIntervalSince1970: item.dt)
            return calendar.startOfDay(for: date)
        }
        var result: [ForecastItem] = []
        for (day, items) in grouped {
            let noon = day.timeIntervalSince1970 + 12 * 3600
            let closest = items.min(by: { abs($0.dt - noon) < abs($1.dt - noon) })
            if let closest = closest {
                result.append(closest)
            }
        }
        return result.sorted { $0.dt < $1.dt }
    }

    // Loads weather and forecast for a given CLLocationCoordinate2D
    func loadWeather(for location: CLLocationCoordinate2D) async {
        isLoading = true
        errorMessage = nil
        isOffline = false
        // Clear previous data to prevent inconsistencies
        currentWeather = nil
        forecast = []
        
        do {
            async let weatherTask = weatherRepository.getCurrentWeather(for: location)
            async let forecastTask = weatherRepository.getForecast(for: location)
            
            let (weather, forecastData) = try await (weatherTask, forecastTask)
            
            currentWeather = weather
            forecast = forecastData
            lastUpdated = Date()
            isOffline = false
            print("✅ Weather loaded successfully for location: \(location.latitude), \(location.longitude)")
        } catch {
            print("❌ Weather loading error: \(error.localizedDescription)")
            print("❌ Error details: \(error)")
            errorMessage = error.localizedDescription
            isOffline = true
        }
        
        isLoading = false
    }
    
    // Loads weather and forecast for a FavouriteLocation (from cache or API)
    func loadWeatherForFavourite(_ location: FavouriteLocation) async {
        isLoading = true
        errorMessage = nil
        isOffline = false
        // Clear previous data to prevent inconsistencies
        currentWeather = nil
        forecast = []
        
        do {
            let (weather, forecastData) = try await weatherRepository.getWeatherForFavourite(location)
            
            currentWeather = weather
            forecast = forecastData
            lastUpdated = Date()
            isOffline = false
        } catch {
            errorMessage = error.localizedDescription
            isOffline = true
        }
        
        isLoading = false
    }
}
