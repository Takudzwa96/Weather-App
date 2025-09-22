import Foundation

/// WeatherService handles network requests to the OpenWeather API for current weather and forecast data.
class WeatherService: WeatherServiceProtocol {
    private var apiKey: String {
        return AppConfiguration.openWeatherAPIKey
    }

    /// Fetches current weather data for the given latitude and longitude
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        guard !apiKey.isEmpty else {
            throw WeatherServiceError.missingAPIKey
        }
        
        guard let url = URL(string:
          "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        ) else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw WeatherServiceError.unauthorized
            case 429:
                throw WeatherServiceError.rateLimitExceeded
            case 408:
                throw WeatherServiceError.timeout
            default:
                throw WeatherServiceError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                throw WeatherServiceError.decodingError(error.localizedDescription)
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.networkError(error.localizedDescription)
        }
    }

    /// Fetches 5-day forecast data for the given latitude and longitude
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResponse {
        guard !apiKey.isEmpty else {
            throw WeatherServiceError.missingAPIKey
        }
        
        guard let url = URL(string:
          "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        ) else {
            throw WeatherServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw WeatherServiceError.unauthorized
            case 429:
                throw WeatherServiceError.rateLimitExceeded
            case 408:
                throw WeatherServiceError.timeout
            default:
                throw WeatherServiceError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(ForecastResponse.self, from: data)
            } catch {
                throw WeatherServiceError.decodingError(error.localizedDescription)
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.networkError(error.localizedDescription)
        }
    }
}
