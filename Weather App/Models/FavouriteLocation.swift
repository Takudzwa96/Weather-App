import Foundation

struct FavouriteLocation: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let placeId: String?
    
    init(name: String, latitude: Double, longitude: Double, placeId: String? = nil) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.placeId = placeId
    }
} 