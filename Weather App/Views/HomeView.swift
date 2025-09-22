import SwiftUI
import CoreLocation
import UIKit

/// HomeView is the main container for the app, providing tab navigation between weather, favourites, search, and map views.
struct HomeView: View {
    @StateObject private var favouritesVM: FavouritesViewModel
    @StateObject private var locationService = LocationService()
    @State private var selectedLocation: FavouriteLocation?
    @State private var showSearch = false
    @State private var showMap = false
    @State private var showFavourites = false
    @State private var showSettings = false
    
    init() {
        // Create dependencies directly
        let placesService = PlacesService()
        let appStorage = AppStorageService()
        let locationRepository = LocationRepository(placesService: placesService, appStorage: appStorage)
        
        self._favouritesVM = StateObject(wrappedValue: FavouritesViewModel(
            locationRepository: locationRepository,
            appStorage: appStorage
        ))
    }                  
    
    var body: some View {
        TabView {
            // Main Weather View (current or selected location)
            NavigationView {
                MainView(selectedLocation: selectedLocation, onClearLocation: {
                    selectedLocation = nil
                })
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(false)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: { showSearch = true }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                        }
                        Button(action: { showFavourites = true }) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                        }
                        Button(action: { showMap = true }) {
                            Image(systemName: "map")
                                .foregroundColor(.white)
                        }
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
                // Sheet for searching locations
                .sheet(isPresented: $showSearch) {
                    LocationSearchView { place in
                        let fav = FavouriteLocation(name: place.name, latitude: place.latitude, longitude: place.longitude, placeId: place.placeId)
                        favouritesVM.addFavourite(fav)
                        selectedLocation = fav
                        showSearch = false
                    }
                }
                // Sheet for viewing favourites
                .sheet(isPresented: $showFavourites) {
                    FavouritesListView(viewModel: favouritesVM) { fav in
                        selectedLocation = fav
                        showFavourites = false
                    }
                }
                // Sheet for viewing map
                .sheet(isPresented: $showMap) {
                    if #available(iOS 17.0, *) {
                        FavouritesMapView(viewModel: favouritesVM, userLocation: locationService.location)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                // Sheet for settings
                .sheet(isPresented: $showSettings) {
                    if #available(iOS 14.0, *) {
                        SettingsView()
                    } else {
                        // Fallback for earlier versions
                        Text("Settings not available on this iOS version")
                    }
                }
            }
            .tabItem {
                Image(systemName: "cloud.sun.fill")
                Text("Weather")
            }
            // Favourites Tab
            FavouritesListView(viewModel: favouritesVM) { fav in
                selectedLocation = fav
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favourites")
            }
            // Map Tab
            if #available(iOS 17.0, *) {
                FavouritesMapView(viewModel: favouritesVM, userLocation: locationService.location)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
            } else {
                // Fallback on earlier versions
            }
            // Settings Tab
            if #available(iOS 14.0, *) {
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            } else {
                // Fallback for earlier versions
                Text("Settings not available on this iOS version")
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    HomeView()
} 
