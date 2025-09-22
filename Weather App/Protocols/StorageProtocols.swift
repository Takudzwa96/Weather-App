//
//  StorageProtocols.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import Foundation

//simple protocols so persistence can be injected & mocked in tests.
protocol FavouriteStorage {
    func loadFavourites() -> [FavouriteLocation]
    func saveFavourites(_ locations: [FavouriteLocation])
    func addFavourite(_ location: FavouriteLocation)
    func removeFavourite(_ location: FavouriteLocation)
}

protocol WeatherCacheStorage {
    func loadCache() -> [CachedWeather]
    func saveCache(_ cache: [CachedWeather])
    func cacheWeather(_ cached: CachedWeather)
    func getCachedWeather(for location: FavouriteLocation) -> CachedWeather?
}
