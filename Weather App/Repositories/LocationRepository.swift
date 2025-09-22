import Foundation
import SwiftUI

/// LocationRepository manages searching for locations, and handling the user's list of favourite locations.
@MainActor
class LocationRepository: ObservableObject {
    private let placesService: any PlacesServiceProtocol  // Service for Google Places API
    private let appStorage: AppStorageService             // AppStorage service for reactive storage
    
    init(placesService: any PlacesServiceProtocol, appStorage: AppStorageService) {
        self.placesService = placesService
        self.appStorage = appStorage
    }
    
    // MARK: - Public Interface
    /// Searches for locations using the Google Places API
    func searchLocations(query: String) async throws -> [PlaceResult] {
        return try await placesService.searchPlaces(query: query)
    }
    
    /// Returns the list of favourite locations from AppStorage
    func getFavourites() -> [FavouriteLocation] {
        return appStorage.favourites
    }
    
    /// Adds a location to the list of favourites
    func addFavourite(_ location: FavouriteLocation) {
        appStorage.addFavourite(location)
    }
    
    /// Removes a location from the list of favourites
    func removeFavourite(_ location: FavouriteLocation) {
        appStorage.removeFavourite(location)
    }
    
    /// Checks if a location is already a favourite
    func isFavourite(_ location: FavouriteLocation) -> Bool {
        return appStorage.favourites.contains(location)
    }
    
    /// Toggles the favourite status of a location
    func toggleFavourite(_ location: FavouriteLocation) {
        if isFavourite(location) {
            removeFavourite(location)
        } else {
            addFavourite(location)
        }
    }
} 