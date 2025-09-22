import Foundation
import CoreLocation

/// LocationService manages Core Location updates and publishes the user's current location.
class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()                 // Core Location manager
    @Published var location: CLLocationCoordinate2D?          // Published user location
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Async location request support
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?

    /// Initializes the location manager and requests permission
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }
    
    /// Requests location permission asynchronously
    func requestLocationPermission() async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            authorizationContinuation = continuation
            
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                continuation.resume(returning: manager.authorizationStatus)
            case .authorizedWhenInUse, .authorizedAlways:
                continuation.resume(returning: manager.authorizationStatus)
            @unknown default:
                continuation.resume(returning: .notDetermined)
            }
        }
    }
    
    /// Gets the current location asynchronously
    func getCurrentLocation() async throws -> CLLocationCoordinate2D? {
        let status = await requestLocationPermission()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied:
            throw LocationServiceError.permissionDenied
        case .restricted:
            throw LocationServiceError.permissionRestricted
        case .notDetermined:
            throw LocationServiceError.permissionDenied
        @unknown default:
            throw LocationServiceError.unknown("Unknown authorization status")
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }
    
    /// Starts continuous location updates
    func startLocationUpdates() {
        let status = manager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        manager.startUpdatingLocation()
    }
    
    /// Stops continuous location updates
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
    }

    /// Called when the location manager receives new location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first?.coordinate else { return }
        
        location = newLocation
        
        // Resume async continuation if waiting for location
        if let continuation = locationContinuation {
            locationContinuation = nil
            continuation.resume(returning: newLocation)
        }
    }

    /// Called when the location manager fails to get a location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        
        // Map CLError to LocationServiceError
        let locationError: LocationServiceError
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = .permissionDenied
            case .locationUnknown:
                locationError = .locationUnavailable
            case .network:
                locationError = .networkError
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed:
                locationError = .serviceDisabled
            default:
                locationError = .unknown(clError.localizedDescription)
            }
        } else {
            locationError = .unknown(error.localizedDescription)
        }
        
        // Resume async continuation with error if waiting for location
        if let continuation = locationContinuation {
            locationContinuation = nil
            continuation.resume(throwing: locationError)
        }
    }
    
    /// Called when authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        // Resume async continuation if waiting for authorization
        if let continuation = authorizationContinuation {
            authorizationContinuation = nil
            continuation.resume(returning: status)
        }
    }
}

