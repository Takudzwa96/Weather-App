import Foundation

struct CachedWeather: Codable {
    let location: FavouriteLocation
    let weatherData: WeatherResponse
    let forecastData: [ForecastItem]
    let lastUpdated: Date
} 