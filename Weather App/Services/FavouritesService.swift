import Foundation

// FavouritesService handles the persistent storage and retrieval of favourite locations using UserDefaults.
/// Conforms to FavouriteStorage so it can be injected and mocked.
class FavouritesService: FavouriteStorage {
    private let key = "favouriteLocations" // UserDefaults key for storing favourites
    
    /// Loads the list of favourite locations from UserDefaults
    func loadFavourites() -> [FavouriteLocation] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([FavouriteLocation].self, from: data)) ?? []
    }
    
    /// Saves the list of favourite locations to UserDefaults
    func saveFavourites(_ locations: [FavouriteLocation]) {
        let data = try? JSONEncoder().encode(locations)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /// Adds a new favourite location if it doesn't already exist
    func addFavourite(_ location: FavouriteLocation) {
        var favs = loadFavourites()
        if !favs.contains(location) {
            favs.append(location)
            saveFavourites(favs)
        }
    }
    
    /// Removes a favourite location
    func removeFavourite(_ location: FavouriteLocation) {
        var favs = loadFavourites()
        favs.removeAll { $0 == location }
        saveFavourites(favs)
    }
} 
