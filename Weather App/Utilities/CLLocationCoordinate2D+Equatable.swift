import CoreLocation

// Extension to make CLLocationCoordinate2D conform to Equatable for easy comparison in models and collections.
extension CLLocationCoordinate2D: @retroactive Equatable {
    /// Compares two CLLocationCoordinate2D values for equality based on latitude and longitude.
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
} 
