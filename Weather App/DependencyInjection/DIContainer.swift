//
//  DIContainer.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/23.
//

import Foundation
import SwiftUI

// Dependency Injection Container for managing service dependencies
@MainActor
class DIContainer: ObservableObject {
    
    // MARK: - Singleton
    static let shared = DIContainer()
    
    // MARK: - Services
    private var services: [String: Any] = [:]
    
    private init() {
        registerServices()
    }
    
    // MARK: - Registration
    private func registerServices() {
        // Core Services - Register protocols with concrete implementations
        register(WeatherServiceProtocol.self, instance: WeatherService())
        register(PlacesServiceProtocol.self, instance: PlacesService())
        register((any LocationServiceProtocol).self, instance: LocationService())
        
        
        register(WeatherService.self, instance: resolve(WeatherServiceProtocol.self) as! WeatherService)
        register(PlacesService.self, instance: resolve(PlacesServiceProtocol.self) as! PlacesService)
        register(LocationService.self, instance: resolve((any LocationServiceProtocol).self) as! LocationService)
        
        register(FavouritesService.self, instance: FavouritesService())
        register(WeatherCacheService.self, instance: WeatherCacheService())
        register(AppStorageService.self, instance: AppStorageService())
        
        // Repositories - Register after services
        register(WeatherRepository.self, instance: WeatherRepository(
            weatherService: resolve(WeatherServiceProtocol.self),
            appStorage: resolve(AppStorageService.self)
        ))
        register(LocationRepository.self, instance: LocationRepository(
            placesService: resolve(PlacesServiceProtocol.self),
            appStorage: resolve(AppStorageService.self)
        ))
        
        // ViewModels - Register after repositories
        register(WeatherViewModel.self, instance: WeatherViewModel(
            weatherRepository: resolve(WeatherRepository.self),
            locationService: resolve((any LocationServiceProtocol).self)
        ))
        register(FavouritesViewModel.self, instance: FavouritesViewModel(
            locationRepository: resolve(LocationRepository.self),
            appStorage: resolve(AppStorageService.self)
        ))
    }
    
    // MARK: - Public Methods
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        services[key] = instance
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = services[key] as? T else {
            fatalError("Service of type \(type) not registered")
        }
        return service
    }
    
    // MARK: - Factory Methods
    func makeWeatherViewModel() -> WeatherViewModel {
        return WeatherViewModel(
            weatherRepository: resolve(WeatherRepository.self),
            locationService: resolve(LocationService.self)
        )
    }
    
    func makeFavouritesViewModel() -> FavouritesViewModel {
        return FavouritesViewModel(
            locationRepository: resolve(LocationRepository.self),
            appStorage: resolve(AppStorageService.self)
        )
    }
    
    func makeLocationService() -> LocationService {
        return resolve(LocationService.self)
    }
}

// MARK: - Environment Key
struct DIContainerKey: EnvironmentKey {
    static let defaultValue = DIContainer.shared
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
