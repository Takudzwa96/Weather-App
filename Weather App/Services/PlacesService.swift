import Foundation

/// PlaceResult represents a single location result from the Google Places API.
struct PlaceResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let placeId: String
}

/// PlacesService handles searching for places using the Google Places API.
class PlacesService: PlacesServiceProtocol {
    private var apiKey: String {
        return AppConfiguration.googlePlacesAPIKey
    }
    
    /// Searches for places matching the query string using the Google Places API
    func searchPlaces(query: String) async throws -> [PlaceResult] {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PlacesServiceError.invalidQuery
        }
        
        guard !apiKey.isEmpty else {
            throw PlacesServiceError.missingAPIKey
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw PlacesServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw PlacesServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                throw PlacesServiceError.unauthorized
            case 429:
                throw PlacesServiceError.rateLimitExceeded
            case 408:
                throw PlacesServiceError.timeout
            default:
                throw PlacesServiceError.httpError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(GPlacesResponse.self, from: data)
                let results = decoded.results.map { r in
                    PlaceResult(name: r.name, latitude: r.geometry.location.lat, longitude: r.geometry.location.lng, placeId: r.place_id)
                }
                
                guard !results.isEmpty else {
                    throw PlacesServiceError.noResults
                }
                
                return results
            } catch let decodingError {
                throw PlacesServiceError.decodingError(decodingError.localizedDescription)
            }
        } catch let error as PlacesServiceError {
            throw error
        } catch {
            throw PlacesServiceError.networkError(error.localizedDescription)
        }
    }
    
    /// Legacy completion-based method for backward compatibility
    func searchPlaces(query: String, completion: @escaping ([PlaceResult]) -> Void) {
        Task {
            do {
                let results = try await searchPlaces(query: query)
                await MainActor.run {
                    completion(results)
                }
            } catch {
                await MainActor.run {
                    completion([])
                }
            }
        }
    }
}


// MARK: - Google Places API Response Models
/// GPlacesResponse represents the top-level response from the Google Places API.
struct GPlacesResponse: Codable {
    let results: [GPlace]
}
/// GPlace represents a single place result from the API.
struct GPlace: Codable {
    let name: String
    let geometry: GGeometry
    let place_id: String
}
/// GGeometry represents the geometry field in a place result.
struct GGeometry: Codable {
    let location: GLocation
}
/// GLocation represents the latitude and longitude of a place.
struct GLocation: Codable {
    let lat: Double
    let lng: Double
} 