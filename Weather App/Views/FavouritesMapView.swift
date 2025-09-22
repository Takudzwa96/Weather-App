import SwiftUI
import MapKit

// FavouritesMapView displays all favourite locations as pins on a map, along with the user's current location.
@available(iOS 17.0, *)
struct FavouritesMapView: View {
    @ObservedObject var viewModel: FavouritesViewModel
    var userLocation: CLLocationCoordinate2D?
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            // Add markers for favourite locations
            ForEach(viewModel.favourites) { location in
                Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    .tint(.blue)
            }
            
            // Add user location if available
            if userLocation != nil {
                UserAnnotation()
            }
        }
        .onAppear {
            // Center the map on the first favourite or user location
            if let first = viewModel.favourites.first {
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                ))
            } else if let userLoc = userLocation {
                position = .region(MKCoordinateRegion(
                    center: userLoc,
                    span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
                ))
            }
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        let mockPlacesService = PlacesService()
        let mockAppStorage = AppStorageService()
        let mockLocationRepository = LocationRepository(placesService: mockPlacesService, appStorage: mockAppStorage)
        let mockViewModel = FavouritesViewModel(locationRepository: mockLocationRepository, appStorage: mockAppStorage)
        
        FavouritesMapView(viewModel: mockViewModel, userLocation: nil)
    }
} 
