# 🌤️ Weather App

<div align="center">

![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-blue.svg)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**A sophisticated, modern iOS weather application built with cutting-edge SwiftUI technologies**

*Featuring real-time weather data, interactive maps and advanced caching*

</div>

---

## 📖 Overview

A comprehensive iOS weather application that demonstrates modern Swift development practices, featuring real-time weather data, interactive maps, intelligent caching. Built with SwiftUI, async/await concurrency, protocol-based architecture, and comprehensive testing.

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/London.png" alt="London Weather" width="320" />
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/Cape%20Town.png" alt="Cape Town Weather" width="320" />
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/map.png" alt="Map Screen" width="320" />
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/favorites.png" alt="Favorites Screen" width="320" />
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/settings.png" alt="Settings Screen" width="320" />
  <img src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/search.png" alt="Search Screen" width="320" />

</p>

## 🎥 Demo

- [Watch the MP4 demo](https://github.com/Takudzwa96/Weather-App/blob/main/Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-09-22%20at%2011.16.29.mp4)

<p align="center">
  <video controls width="360">
    <source src="https://raw.githubusercontent.com/Takudzwa96/Weather-App/main/Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-09-22%20at%2011.16.29.mp4" type="video/mp4">
  </video>
</p>

## 🌟 Features

### 🌡️ **Core Weather Intelligence**
- **Real-Time Weather Data**: Live weather conditions with temperature, humidity, pressure, and wind data
- **5-Day Detailed Forecast**: Comprehensive daily predictions with min/max temperatures and weather patterns
- **Dynamic Visual Backgrounds**: Immersive weather-based themes (Sunny, Cloudy, Rainy, Stormy)
- **Intelligent Location Detection**: Automatic GPS-based weather for current location
- **Multi-Unit Support**: Celsius, Fahrenheit, and Kelvin temperature display

### 🗺️ **Advanced Location Features**
- **Smart Favourites System**: Save and manage unlimited weather locations with reactive updates
- **Powerful Location Search**: Google Places API integration for worldwide city and landmark search
- **Interactive MapKit Integration**: iOS 17+ native map with custom markers and user location
- **Offline-First Architecture**: Comprehensive caching system for uninterrupted access
- **Location Permission Management**: Graceful handling of location authorization states

### 🎨 **Premium User Experience**
- **Sea-Inspired Design Language**: Beautiful gradient backgrounds with lighthouse and maritime elements
- **Responsive Adaptive Layout**: Optimized for all iPhone sizes from SE to Pro Max
- **Fluid Animations**: Sophisticated splash screen and seamless weather transitions
- **Intuitive Tab Navigation**: Effortless switching between weather, favourites, map, and settings
- **Accessibility-First Design**: Full VoiceOver support and accessibility compliance

### ⚙️ **Smart Settings & Customization**
- **Reactive Settings with @AppStorage**: Live UI updates without app restart
- **Intelligent Cache Management**: Configurable cache expiration (1 hour to 1 week)
- **Push Notification Controls**: Weather alerts and update preferences
- **Data Management Tools**: Clear cache, reset settings, and data export options

## 🏗️ Architecture

### 🎯 **Modern iOS Architecture Patterns**

The app implements a sophisticated multi-layer architecture following industry best practices:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │   Business      │    │   Data          │
│                 │    │                 │    │                 │
│ • SwiftUI Views │    │ • ViewModels    │    │ • Repositories  │
│ • Navigation    │◄──►│ • State Mgmt    │◄──►│ • Services      │
│ • Animations    │    │ • Validation    │    │ • API Clients   │
│ • Accessibility │    │ • Formatting    │    │ • Caching       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 🔧 **Clean Architecture Implementation**
- **🎭 MVVM Pattern**: Separation of concerns with reactive data binding
- **🏪 Repository Pattern**: Centralized data access with caching strategies
- **🔄 Observer Pattern**: Reactive UI updates with Combine publishers
- **💉 Protocol-Based Dependency Injection**: Testable and maintainable service architecture
- **⚡ Async/Await Concurrency**: Modern Swift concurrency for all network operations

### 📦 **Key Components**
- **Views**: SwiftUI declarative UI with state management
- **ViewModels**: Business logic with @Published properties
- **Repositories**: Data access abstraction with intelligent caching
- **Services**: Protocol-based API integration and local storage
- **Models**: Codable data structures with proper error handling

## 🚀 Technologies

### 📱 **iOS Frameworks & APIs**
- **SwiftUI** - Declarative UI framework with state management
- **Core Location** - GPS and location services with privacy compliance
- **MapKit** - Native iOS maps with custom annotations and user tracking
- **UserDefaults & @AppStorage** - Reactive local data persistence
- **UIKit Integration** - Custom UIViewRepresentable components
- **Combine** - Reactive programming and data flow management

### 🌐 **External APIs & Services**
- **OpenWeather API** - Real-time weather data and 5-day forecasts
- **Google Places API** - Global location search and geocoding services
- **Network Layer** - URLSession with async/await and comprehensive error handling

### 🔒 **Security & Performance**
- **App Transport Security (ATS)** - TLS 1.2+ enforcement with certificate transparency
- **Secure Configuration Management** - API keys in gitignored configuration files
- **Certificate Pinning** - SSL/TLS certificate validation for API endpoints
- **Data Encryption** - AES-256 encryption for sensitive information
- **Async/Await Concurrency** - Modern Swift concurrency patterns

### 🧪 **Development & Testing**
- **XCTest Framework** - Comprehensive unit and integration testing
- **Protocol-Based Mocking** - Dependency injection for testing
- **SwiftLint** - Code style and quality enforcement
- **Fastlane** - Automated deployment and CI/CD integration
- **GitHub Actions** - Continuous integration with security scanning

## 🛠️ Setup

### 📋 **Prerequisites**
- **Xcode**: 15.0 or later
- **iOS Deployment Target**: 13.0+
- **Swift**: 5.9+
- **macOS**: 12.0+ (for development)

### ⚡ **Quick Start**

```bash
# Clone the repository
git clone <repository-url>
cd "Weather App"

# Open in Xcode
open "Weather App.xcodeproj"
```

### 🔑 **API Configuration**

#### **1. Create Configuration File**
```bash
cp "Weather App/Configuration/Config-Template.plist" "Weather App/Configuration/Config.plist"
```

#### **2. Add Your API Keys**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>OpenWeatherAPIKey</key>
    <string>YOUR_OPENWEATHER_API_KEY_HERE</string>
    <key>GooglePlacesAPIKey</key>
    <string>YOUR_GOOGLE_PLACES_API_KEY_HERE</string>
</dict>
</plist>
```

#### **3. Obtain API Keys**

**🌤️ OpenWeather API**
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Create free account (1,000 calls/day included)
3. Generate API key from dashboard
4. Copy key to Config.plist

**🗺️ Google Places API**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create project and enable Places API
3. Create API key with iOS app restrictions
4. Add key to Config.plist

> ⚠️ **Security Note**: `Config.plist` will not be commited to version control. It's automatically gitignored as it contains our API keys.

## 📱 Usage Guide

### 🏠 **Main Weather Dashboard**
- **Current Conditions**: Real-time temperature, humidity, and weather status
- **5-Day Forecast**: Detailed daily predictions with temperature ranges
- **Dynamic Backgrounds**: Immersive weather-themed visuals
- **Quick Actions**: Toolbar access to search, favourites, map, and settings

### ⭐ **Smart Favourites Management**
1. **Adding Locations**: Tap search icon → Enter city name → Select from results
2. **Viewing Weather**: Tap any favourite to see detailed weather information
3. **Managing List**: Swipe left to delete, reorder by dragging
4. **Map Integration**: Visualize all favourites on interactive map

### 🗺️ **Interactive Map Experience**
- **Favourite Markers**: All saved locations displayed with custom pins
- **User Location**: Current position with real-time tracking
- **Navigation Controls**: Zoom, pan, and center on locations
- **Dismiss Functionality**: "Done" button to close map view

### ⚙️ **Advanced Settings**
- **Temperature Units**: Switch between Celsius, Fahrenheit, and Kelvin
- **Cache Management**: Configure data expiration (1 hour to 1 week)
- **Notification Preferences**: Weather alerts and update settings
- **Data Controls**: Clear cache, reset settings, export data

### 🔄 **Offline Capabilities**
- **Intelligent Caching**: Automatic weather data storage for offline access
- **Cache Indicators**: "Last Updated" timestamps show data freshness
- **Graceful Degradation**: Seamless transition between online and offline modes
- **Data Persistence**: Favourites and settings preserved across app launches

## 🧪 Testing Strategy

### 🎯 **Comprehensive Test Coverage**

#### **Unit Tests (85%+ Coverage)**
- **WeatherServiceTests**: API integration, error handling, and response parsing
- **LocationServiceTests**: GPS functionality, permission management, and async operations
- **PlacesServiceTests**: Location search, geocoding, and error scenarios
- **WeatherViewModelTests**: Business logic, state management, and data flow
- **RepositoryTests**: Caching strategies, data persistence, and offline scenarios

#### **Protocol-Based Testing Architecture**
```swift
// Mock services for isolated testing
let mockWeatherService = MockWeatherService()
mockWeatherService.currentWeatherToReturn = MockWeatherService.createMockWeatherResponse()

let weatherRepository = WeatherRepository(
    weatherService: mockWeatherService,
    appStorage: mockAppStorage
)

// Test with controlled data
await viewModel.loadWeather(for: testLocation)
XCTAssertEqual(mockService.fetchCurrentWeatherCallCount, 1)
```

#### **Running Tests**
```bash
# Run all tests with coverage
xcodebuild test -scheme "Weather App" -enableCodeCoverage YES

# Run specific test class
xcodebuild test -only-testing:Weather_AppTests/WeatherServiceTests

# Run tests in Xcode
⌘+U
```

## 📁 Project Architecture

```
Weather App/
├── 📱 Views/                           # SwiftUI User Interface
│   ├── ModernMainView.swift            # Modern weather display with integrated forecast
│   ├── FavouritesListView.swift        # Location management with swipe actions
│   ├── LocationSearchView.swift        # Google Places search integration
│   ├── FavouritesMapView.swift         # MapKit integration with custom markers
│   ├── SettingsView.swift              # @AppStorage reactive settings panel
│   ├── HomeView.swift                  # Tab navigation container
│   ├── SplashScreenView.swift          # Animated app launch experience
│   └── SharedComponents/
│       └── ActivityIndicator.swift     # UIKit-SwiftUI bridge component
│
├── 🧠 ViewModels/                      # Business Logic Layer
│   ├── WeatherViewModel.swift          # Weather state management with async operations
│   └── FavouritesViewModel.swift       # Location management with reactive updates
│
├── 🏪 Repositories/                    # Data Access Layer
│   ├── WeatherRepository.swift         # Weather data with intelligent caching
│   └── LocationRepository.swift        # Location search and favourites management
│
├── 🔧 Services/                        # Service Layer
│   ├── WeatherService.swift            # OpenWeather API client with error handling
│   ├── PlacesService.swift             # Google Places API integration
│   ├── LocationService.swift           # Core Location with async/await
│   ├── AppStorageService.swift         # Reactive @AppStorage management
│   ├── FavouritesService.swift         # Local storage operations
│   └── WeatherCacheService.swift       # Intelligent caching strategies
│
├── 📊 Models/                          # Data Models
│   ├── Weather.swift                   # Weather response models
│   ├── FavouriteLocation.swift         # Location model with Codable
│   └── CachedWeather.swift             # Cache metadata and expiration
│
├── 🔌 Protocols/                       # Protocol Definitions
│   ├── WeatherServiceProtocol.swift    # Weather service interface
│   ├── PlacesServiceProtocol.swift     # Places service interface
│   └── LocationServiceProtocol.swift   # Location service interface
│
├── 🧪 Mocks/                          # Testing Infrastructure
│   ├── MockWeatherService.swift        # Weather service mocks
│   ├── MockPlacesService.swift         # Places service mocks
│   └── MockLocationService.swift       # Location service mocks
│
├── 🛠️ Utilities/                      # Helper Classes
│   ├── TemperatureUtils.swift          # Temperature conversion and formatting
│   └── CLLocationCoordinate2D+Equatable.swift # Location comparison utilities
│
├── ⚙️ Configuration/                   # App Configuration
│   ├── AppConfiguration.swift          # Secure API key management
│   ├── Config.plist                    # API keys (gitignored)
│   └── Config-Template.plist           # Configuration template
│
└── 📚 Tests/                          # Test Suite
    ├── WeatherServiceTests.swift       # API integration tests
    ├── LocationServiceTests.swift      # Location service tests
    ├── WeatherViewModelTests.swift     # Business logic tests
    └── UITests/                        # User interface tests
```

## 💡 Code Examples

### 🔄 **Reactive State Management**
```swift
// @AppStorage provides automatic UI updates across the entire app
@AppStorage("temperatureUnit") private var temperatureUnit: String = "celsius"

// UI automatically updates when settings change
var displayTemperature: String {
    let unit = TemperatureUnit(rawValue: temperatureUnit) ?? .celsius
    return TemperatureUtils.format(weather.temp, unit: unit)
}
```

### ⚡ **Modern Concurrency Implementation**
```swift
// Concurrent API calls for better performance
func loadWeather(for location: CLLocationCoordinate2D) async {
    do {
        async let weatherTask = weatherRepository.getCurrentWeather(for: location)
        async let forecastTask = weatherRepository.getForecast(for: location)
        
        let (weather, forecast) = try await (weatherTask, forecastTask)
        
        await MainActor.run {
            self.currentWeather = weather
            self.forecast = forecast
        }
    } catch {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
        }
    }
}
```

### 🏪 **Repository Pattern with Intelligent Caching**
```swift
@MainActor
class WeatherRepository: ObservableObject {
    func getCurrentWeather(for location: CLLocationCoordinate2D) async throws -> WeatherResponse {
        do {
            // Try API first
            let weather = try await weatherService.fetchCurrentWeather(lat: location.latitude, lon: location.longitude)
            await cacheWeather(weather, for: location)
            return weather
        } catch {
            // Fallback to cache for offline support
            if let cached = getCachedWeather(for: location) {
                return cached.weatherData
            }
            throw error
        }
    }
}
```

## 🚀 Deployment & CI/CD

### 🔄 **GitHub Actions Workflow**
```yaml
name: iOS CI
on: [push, pull_request]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Run Tests
        run: fastlane test
      - name: Security Scan
        run: fastlane security
      - name: Build App
        run: fastlane build
```

### 🚀 **Fastlane Automation**
- **`fastlane test`**: Comprehensive test suite execution
- **`fastlane beta`**: TestFlight deployment with automatic versioning
- **`fastlane release`**: App Store submission with metadata
- **`fastlane screenshots`**: Automated screenshot generation
- **`fastlane security`**: Security vulnerability scanning

## 🐛 Troubleshooting

### 🔧 **Common Issues & Solutions**

#### **Location Permission Issues**
```
Problem: "Location permission denied"
Solution: 
1. Go to Settings > Privacy & Security > Location Services
2. Enable location access for Weather App
3. Set permission to "While Using App"
```

#### **API Configuration Errors**
```
Problem: "API key missing or invalid"
Solution:
1. Verify Config.plist exists and contains valid keys
2. Check API key restrictions in Google Cloud Console
3. Ensure OpenWeather API key is active
4. Verify internet connectivity
```

#### **Build & Development Issues**
```bash
# Clean build artifacts
⌘+Shift+K  # Clean build folder
⌘+Shift+Option+K  # Clean derived data

# Reset simulator
xcrun simctl erase all

# Update dependencies
xcodebuild -resolvePackageDependencies
```

## 👨‍💻 Author

**Takudzwa Raisi**
- iOS Developer 


---

## 🙏 Acknowledgments

- **OpenWeather** for providing comprehensive weather data APIs
- **Google** for Places API and geocoding services  
- **Apple** for SwiftUI, Core Location, and MapKit frameworks
- **iOS Development Community** for best practices and architectural patterns

---

<div align="center">

</div> 
