import SwiftUI

/// LocationSearchView allows the user to search for cities or places and select one to add to favourites.
struct LocationSearchView: View {
    @State private var query = ""                                 // Search query string
    @State private var results: [PlaceResult] = []                // Search results
    @State private var isLoading = false                          // Loading state
    @StateObject private var locationRepository: LocationRepository // Repository for searching locations
    var onSelect: (PlaceResult) -> Void                           // Callback when a place is selected
    @Environment(\.presentationMode) var presentationMode
    
    init(onSelect: @escaping (PlaceResult) -> Void) {
        self.onSelect = onSelect
        
        // Create dependencies directly
        let placesService = PlacesService()
        let appStorage = AppStorageService()
        let repository = LocationRepository(placesService: placesService, appStorage: appStorage)
        
        self._locationRepository = StateObject(wrappedValue: repository)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for a city or place", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Search") {
                        search()
                    }
                }
                .padding()
                if isLoading {
                    ActivityIndicator(isAnimating: .constant(true), style: .medium, color: .blue)
                }
                List(results) { place in
                    Button(action: { onSelect(place) }) {
                        VStack(alignment: .leading) {
                            Text(place.name)
                            Text("(\(place.latitude), \(place.longitude))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    /// Performs the search using the location repository
    func search() {
        isLoading = true
        Task {
            do {
                let found = try await locationRepository.searchLocations(query: query)
                await MainActor.run {
                    self.results = found
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.results = []
                    self.isLoading = false
                    // Could show error message here
                    print("Search error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    LocationSearchView(onSelect: { _ in })
} 