//
//  ModernMainView.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import SwiftUI
import CoreLocation

// Modern weather display view matching the sophisticated design requirements
struct MainView: View {
    // MARK: - State & Dependencies
    @StateObject private var locationService = LocationService()
    @StateObject private var viewModel: WeatherViewModel
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "celsius"
    var selectedLocation: FavouriteLocation?
    var onClearLocation: (() -> Void)?
    
    init(selectedLocation: FavouriteLocation? = nil, onClearLocation: (() -> Void)? = nil) {
        self.selectedLocation = selectedLocation
        self.onClearLocation = onClearLocation
        
        // Create dependencies
        let weatherService = WeatherService()
        let appStorage = AppStorageService()
        let weatherRepository = WeatherRepository(weatherService: weatherService, appStorage: appStorage)
        let locationService = LocationService()
        
        self._viewModel = StateObject(wrappedValue: WeatherViewModel(
            weatherRepository: weatherRepository,
            locationService: locationService
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Dynamic Weather Background
                weatherBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // MARK: - Header Section
                        VStack(spacing: 24) {
                            // Location name
                            HStack {
                                if let location = selectedLocation {
                                    Button(action: {
                                        onClearLocation?()
                                    }) {
                                        HStack {
                                            Text(location.name)
                                                .font(.system(size: 32, weight: .medium))
                                                .foregroundColor(.white)
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white.opacity(0.7))
                                                .font(.title2)
                                        }
                                    }
                                } else {
                                Text(viewModel.currentWeather?.name ?? "")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(textColor)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Current temperature and condition
                            if let weather = viewModel.currentWeather {
                                VStack(spacing: 8) {
                                    // Large temperature display
                                    HStack(alignment: .top, spacing: 2) {
                                        Text(TemperatureUtils.formatWithoutSymbol(weather.main.temp, unit: TemperatureUnit(rawValue: temperatureUnit) ?? .celsius))
                                            .font(.system(size: 96, weight: .thin))
                                            .foregroundColor(textColor)
                                        Text("°")
                                            .font(.system(size: 48, weight: .thin))
                                            .foregroundColor(textColor)
                                            .padding(.top, 8)
                                    }
                                    
                                    // Weather condition with separator
                                    HStack(spacing: 8) {
                                        Text(weather.weather.first?.description.capitalized ?? "Partly Cloudy")
                                            .font(.title3)
                                            .foregroundColor(textColor)
                                    }
                                }
                            } else {
                                VStack(spacing: 16) {
                                    ActivityIndicator(isAnimating: .constant(true), style: .large, color: .white)
                                        .scaleEffect(1.2)
                                    Text("Loading weather data...")
                                        .font(.body)
                                        .foregroundColor(textColor.opacity(0.8))
                                }
                                .frame(height: 150)
                            }
                        }
                        .frame(height: geometry.size.height * 0.45)
                        
                        // MARK: - Forecast Section
                        VStack(spacing: 0) {
                            // Forecast header
                            HStack {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("5-DAY FORECAST")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.7))
                                        .tracking(1.2)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 16)
                            
                            // Forecast list
                            if !viewModel.forecast.isEmpty {
                                LazyVStack(spacing: 0) {
                                    ForEach(Array(viewModel.dailyForecast.prefix(5).enumerated()), id: \.offset) { index, item in
                                        ModernForecastRow(
                                            item: item,
                                            isToday: index == 0,
                                            temperatureUnit: TemperatureUnit(rawValue: temperatureUnit) ?? .celsius
                                        )
                                        
                                        if index < min(viewModel.dailyForecast.count - 1, 4) {
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                            } else {
                                // Loading state for forecast
                                ForEach(0..<7, id: \.self) { _ in
                                    ModernForecastRowSkeleton()
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.2))
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            loadWeatherForCurrentLocation()
        }
        .onChange(of: locationService.location, perform: { _ in
            if selectedLocation == nil {
                loadWeatherForCurrentLocation()
            }
        })
        .onChange(of: selectedLocation, perform: { _ in
            loadWeatherForSelectedLocation()
        })
    }
    
    // MARK: - Weather Loading Methods
    private func loadWeatherForCurrentLocation() {
        guard selectedLocation == nil else { return }
        
        Task {
            do {
                if let location = try await locationService.getCurrentLocation() {
                    await viewModel.loadWeather(for: location)
                } else {
                    // Fallback to a default location
                    let defaultLocation = CLLocationCoordinate2D(latitude: 33.9221, longitude: 18.4231) // Cape Town
                    await viewModel.loadWeather(for: defaultLocation)
                }
            } catch {
                // Fallback to default location
                let defaultLocation = CLLocationCoordinate2D(latitude: 33.9221, longitude: 18.4231) // Cape Town
                await viewModel.loadWeather(for: defaultLocation)
            }
        }
    }
    
    private func loadWeatherForSelectedLocation() {
        if let location = selectedLocation {
            Task {
                await viewModel.loadWeatherForFavourite(location)
            }
        } else {
            loadWeatherForCurrentLocation()
        }
    }
    
    // MARK: - Dynamic Weather Background
    private var weatherBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundColors),
            startPoint: .top,
            endPoint: .bottom
        )
        .animation(.easeInOut(duration: 1.0), value: backgroundColors.first)
    }
    
    private var backgroundColors: [Color] {
        guard let weather = viewModel.currentWeather?.weather.first?.main.lowercased() else {
            // Default background
            return [
                Color(red: 0.15, green: 0.15, blue: 0.25),
                Color(red: 0.25, green: 0.35, blue: 0.55)
            ]
        }
        
        switch weather {
        case "clear":
            // Sunny - beautiful blue to warm orange/yellow
            return [
                Color(red: 0.1, green: 0.5, blue: 0.9),   // Sky blue
                Color(red: 1.0, green: 0.6, blue: 0.2)    // Sunset orange
            ]
        case "clouds":
            // Cloudy - soft gray to muted blue
            return [
                Color(red: 0.3, green: 0.4, blue: 0.5),   // Cloud gray
                Color(red: 0.2, green: 0.3, blue: 0.5)    // Muted blue
            ]
        case "rain", "drizzle":
            // Rainy - deep blue to stormy gray
            return [
                Color(red: 0.05, green: 0.15, blue: 0.35), // Deep blue
                Color(red: 0.25, green: 0.25, blue: 0.35)  // Stormy gray
            ]
        case "thunderstorm":
            // Stormy - dramatic dark with electric purple
            return [
                Color(red: 0.05, green: 0.05, blue: 0.15), // Very dark
                Color(red: 0.15, green: 0.05, blue: 0.25)  // Electric purple
            ]
        case "snow":
            // Snowy - crisp blue to pure white
            return [
                Color(red: 0.6, green: 0.7, blue: 0.9),   // Winter blue
                Color(red: 0.95, green: 0.95, blue: 1.0)  // Snow white
            ]
        case "mist", "fog", "haze":
            // Foggy - mysterious gray gradients
            return [
                Color(red: 0.4, green: 0.4, blue: 0.5),   // Misty gray
                Color(red: 0.25, green: 0.25, blue: 0.35) // Deep mist
            ]
        case "partly cloudy", "few clouds", "scattered clouds", "broken clouds":
            // Partly cloudy - balanced blue to soft gray
            return [
                Color(red: 0.2, green: 0.4, blue: 0.7),   // Partial blue
                Color(red: 0.4, green: 0.4, blue: 0.6)    // Soft gray
            ]
        default:
            // Default background - elegant dark blue
            return [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5)
            ]
        }
    }
    
    // MARK: - Dynamic Text Color
    private var textColor: Color {
        guard let weather = viewModel.currentWeather?.weather.first?.main.lowercased() else {
            return .white
        }
        
        switch weather {
        case "snow":
            // Dark text for snowy/light backgrounds
            return .black
        case "mist", "fog", "haze":
            // Slightly darker text for foggy conditions
            return Color(red: 0.9, green: 0.9, blue: 0.9)
        default:
            // White text for most conditions
            return .white
        }
    }
}

/// Modern forecast row matching the design
struct ModernForecastRow: View {
    let item: ForecastItem
    let isToday: Bool
    let temperatureUnit: TemperatureUnit
    
    var body: some View {
        HStack(spacing: 16) {
            // Day label
            Text(dayLabel)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            // Weather icon
            Image(systemName: weatherIcon)
                .font(.title2)
                .foregroundColor(weatherIconColor)
                .frame(width: 30)
            
            // Precipitation percentage (if available)
            if let precipitation = item.pop, precipitation > 0 {
                Text("\(Int(precipitation * 100))%")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(red: 0, green: 1, blue: 1))
                    .frame(width: 40, alignment: .leading)
            } else {
                Spacer()
                    .frame(width: 40)
            }
            
            Spacer()
            
            // Temperature range with bar
            HStack(spacing: 8) {
                // Min temperature
                Text(TemperatureUtils.formatWithoutSymbol(item.minTemp ?? item.main.temp - 5, unit: temperatureUnit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 30, alignment: .trailing)
                
                // Temperature range bar
                TemperatureRangeBar(
                    minTemp: item.minTemp ?? item.main.temp - 5,
                    maxTemp: item.maxTemp ?? item.main.temp + 5,
                    currentTemp: item.main.temp
                )
                .frame(width: 80, height: 4)
                
                // Max temperature
                Text(TemperatureUtils.formatWithoutSymbol(item.maxTemp ?? item.main.temp + 5, unit: temperatureUnit))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 30, alignment: .leading)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private var dayLabel: String {
        if isToday {
            return "Today"
        } else {
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: date)
        }
    }
    
    private var weatherIcon: String {
        guard let weatherMain = item.weather.first?.main else { return "cloud" }
        
        switch weatherMain.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain", "drizzle":
            return "cloud.rain.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "snow":
            return "cloud.snow.fill"
        case "mist", "fog":
            return "cloud.fog.fill"
        default:
            return "cloud"
        }
    }
    
    private var weatherIconColor: Color {
        guard let weatherMain = item.weather.first?.main else { return .white }
        
        switch weatherMain.lowercased() {
        case "clear":
            return .yellow  // Yellow sun
        case "clouds":
            return Color(red: 0.8, green: 0.8, blue: 0.8)  // Light gray clouds
        case "rain", "drizzle":
            return Color(red: 0.4, green: 0.6, blue: 0.9)  // Blue rain
        case "thunderstorm":
            return Color(red: 0.9, green: 0.8, blue: 0.2)  // Electric yellow for lightning
        case "snow":
            return Color(red: 0.9, green: 0.9, blue: 1.0)  // Pure white snow
        case "mist", "fog":
            return Color(red: 0.7, green: 0.7, blue: 0.7)  // Gray fog
        default:
            return .white
        }
    }
}

/// Temperature range bar component
struct TemperatureRangeBar: View {
    let minTemp: Double
    let maxTemp: Double
    let currentTemp: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 4)
                
                // Temperature gradient bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(temperatureGradient)
                    .frame(height: 4)
            }
        }
    }
    
    private var temperatureGradient: LinearGradient {
        let colors: [Color] = [
            .blue,      // Cold
            Color(red: 0, green: 1, blue: 1),      // Cool (cyan)
            .green,     // Mild
            .yellow,    // Warm
            .orange,    // Hot
            .red        // Very hot
        ]
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

/// Skeleton loading row for forecast
struct ModernForecastRowSkeleton: View {
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        HStack(spacing: 16) {
            // Day placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 20)
            
            // Icon placeholder
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 24, height: 24)
            
            // Precipitation placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.2))
                .frame(width: 40, height: 16)
            
            Spacer()
            
            // Temperature range placeholder
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 30, height: 20)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 80, height: 4)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 30, height: 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .overlay(
            // Shimmer effect
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: shimmerOffset)
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        shimmerOffset = 200
                    }
                }
        )
        .clipped()
    }
}

#Preview {
    MainView()
}
