//
//  SettingsView.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/18.
//

import SwiftUI

/// SettingsView demonstrates @AppStorage usage for app preferences
@available(iOS 14.0, *)
struct SettingsView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "celsius"
    @AppStorage("cacheExpirationHours") private var cacheExpirationHours: Double = 24
    @AppStorage("enableNotifications") private var enableNotifications: Bool = true
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("lastLocationUpdate") private var lastLocationUpdate: Double = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Temperature Unit")) {
                    Picker("Temperature Unit", selection: $temperatureUnit) {
                        ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                            Text(unit.symbol).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Cache Settings")) {
                    HStack {
                        Text("Cache Expiration")
                        Spacer()
                        Text("\(Int(cacheExpirationHours)) hours")
                    }
                    
                    Slider(
                        value: $cacheExpirationHours,
                        in: 1...168, // 1 hour to 1 week
                        step: 1
                    )
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                }
                
                Section(header: Text("App Information")) {
                    HStack {
                        Text("First Launch")
                        Spacer()
                        Text(isFirstLaunch ? "Yes" : "No")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Last Location Update")
                        Spacer()
                        if lastLocationUpdate > 0 {
                            Text(Date(timeIntervalSince1970: lastLocationUpdate), style: .relative)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Never")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button("Clear Cache") {
                        // Clear cache by setting empty array
                        UserDefaults.standard.removeObject(forKey: "cachedWeatherData")
                    }
                    .foregroundColor(.red)
                    
                    Button("Reset Settings") {
                        temperatureUnit = "celsius"
                        cacheExpirationHours = 24
                        enableNotifications = true
                    }
                    .foregroundColor(.orange)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    SettingsView()
}
