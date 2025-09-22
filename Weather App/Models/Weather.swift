import Foundation

struct WeatherResponse: Codable {
    let weather: [WeatherCondition]
    let main: MainWeather
    let name: String
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
}

struct MainWeather: Codable {
    let temp: Double
    let temp_min: Double?
    let temp_max: Double?
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable, Identifiable {
    var id: UUID { UUID() }
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]
    let pop: Double? // Probability of precipitation (0.0 to 1.0)
    var minTemp: Double? { main.temp_min }
    var maxTemp: Double? { main.temp_max }
}
