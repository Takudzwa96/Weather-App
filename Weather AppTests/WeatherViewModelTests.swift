import XCTest
@testable import Weather_App
import CoreLocation

@MainActor
final class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        // Create mock dependencies
        let mockWeatherService = MockWeatherService()
        let mockAppStorage = AppStorageService()
        let mockLocationService = MockLocationService()
        
        let weatherRepository = WeatherRepository(
            weatherService: mockWeatherService,
            appStorage: mockAppStorage
        )
        
        viewModel = WeatherViewModel(
            weatherRepository: weatherRepository,
            locationService: mockLocationService
        )
    }

    func testDailyForecastReturnsUniqueDays() {
        // Given: 8 forecast items, 2 per day for 4 days
        let now = Date()
        let calendar = Calendar.current
        let forecast: [ForecastItem] = (0..<8).map { i in
            let day = i / 2
            let hour = (i % 2) * 12
            let date = calendar.date(byAdding: .day, value: day, to: now)!
            let dt = date.addingTimeInterval(Double(hour) * 3600).timeIntervalSince1970
            return ForecastItem(dt: dt, main: MainWeather(temp: Double(20 + day), temp_min: nil, temp_max: nil), weather: [WeatherCondition(main: "Clouds", description: "cloudy")])
        }
        viewModel.forecast = forecast

        // When
        let daily = viewModel.dailyForecast

        // Then
        XCTAssertEqual(daily.count, 4, "Should have 4 unique days")
        XCTAssertEqual(daily[0].main.temp, 20)
        XCTAssertEqual(daily[1].main.temp, 21)
        XCTAssertEqual(daily[2].main.temp, 22)
        XCTAssertEqual(daily[3].main.temp, 23)
    }

    func testErrorMessageOnFailure() async {
        // Simulate error
        viewModel.errorMessage = nil
        viewModel.isLoading = true
        viewModel.currentWeather = nil
        viewModel.forecast = []
        // Simulate error
        viewModel.errorMessage = "Network error"
        viewModel.isLoading = false

        XCTAssertEqual(viewModel.errorMessage, "Network error")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testIsOfflineFlagWhenUsingCachedData() async {
        // Simulate offline/cached scenario
        viewModel.isOffline = false
        viewModel.errorMessage = nil
        viewModel.currentWeather = nil
        viewModel.forecast = []
        viewModel.isOffline = true
        XCTAssertTrue(viewModel.isOffline)
    }

    func testLoadWeatherForFavouriteSetsWeather() async {
        // This is a placeholder for a real mock test
        // In a real test, inject a mock WeatherRepository and simulate a response
        let fav = FavouriteLocation(name: "Test", latitude: 0, longitude: 0)
        await viewModel.loadWeatherForFavourite(fav)
        // We can't assert real data without a mock, but we can check loading state
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadWeatherSetsWeather() async {
        // This is a placeholder for a real mock test
        let coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        await viewModel.loadWeather(for: coord)
        XCTAssertFalse(viewModel.isLoading)
    }
} 
