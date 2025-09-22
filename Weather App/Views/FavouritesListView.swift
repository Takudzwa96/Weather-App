import SwiftUI

// FavouritesListView displays a list of the user's favourite locations and allows selection or deletion.
struct FavouritesListView: View {
    @ObservedObject var viewModel: FavouritesViewModel
    var onSelect: (FavouriteLocation) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favourites) { location in
                    Button(action: { onSelect(location) }) {
                        HStack {
                            Text(location.name)
                            Spacer()
                            Text("(\(location.latitude), \(location.longitude))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { idx in
                        let loc = viewModel.favourites[idx]
                        viewModel.removeFavourite(loc)
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    let mockPlacesService = PlacesService()
    let mockAppStorage = AppStorageService()
    let mockLocationRepository = LocationRepository(placesService: mockPlacesService, appStorage: mockAppStorage)
    let mockViewModel = FavouritesViewModel(locationRepository: mockLocationRepository, appStorage: mockAppStorage)
    
    FavouritesListView(viewModel: mockViewModel, onSelect: { _ in })
} 
