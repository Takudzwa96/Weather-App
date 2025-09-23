import Foundation
import SwiftUI

/// FavouritesViewModel manages the list of favourite locations using AppStorageService for reactive UI updates.
@MainActor
class FavouritesViewModel: ObservableObject {
    @Published var favourites: [FavouriteLocation] = []   // List of favourite locations
    private let appStorage: AppStorageService             // AppStorage service for reactive storage
    private let locationRepository: LocationRepository    // Repository for location data
    
    /// Initializes the view model and loads favourites from storage
    init(locationRepository: LocationRepository, appStorage: AppStorageService) {
        self.locationRepository = locationRepository
        self.appStorage = appStorage
        loadFavourites()
    }
    
    /// Loads the list of favourite locations from AppStorage
    func loadFavourites() {
        favourites = appStorage.favourites
    }
    
    /// Adds a new favourite location
    func addFavourite(_ location: FavouriteLocation) {
        appStorage.addFavourite(location)
        favourites = appStorage.favourites
    }
    
    /// Removes a favourite location
    func removeFavourite(_ location: FavouriteLocation) {
        appStorage.removeFavourite(location)
        favourites = appStorage.favourites
    }
    
    /// Toggles the favourite status of a location
    func toggleFavourite(_ location: FavouriteLocation) {
        if isFavourite(location) {
            removeFavourite(location)
        } else {
            addFavourite(location)
        }
    }
    
    /// Checks if a location is already a favourite
    func isFavourite(_ location: FavouriteLocation) -> Bool {
        return favourites.contains(location)
    }
    
    func reverseString(_ str: String) -> String {
        return String (str.reversed())
    }
}
