//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/18.
//

import SwiftUI
import UIKit

@main
struct Weather_AppApp: App {
    @State private var showSplash = true
    @StateObject private var diContainer = DIContainer.shared


    init() {
        setupGlobalAppearance()
    }

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView {
                    showSplash = false
                }
                .environment(\.diContainer, diContainer)
            } else {
                HomeView()
                    .environment(\.diContainer, diContainer)
            }
        }
    }
    
    // MARK: - Global App Appearance Setup
    private func setupGlobalAppearance() {
        // Setup tab bar appearance globally for consistency
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        
        // Translucent background with subtle tint for visibility
        tabAppearance.backgroundColor = UIColor.clear
        tabAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        tabAppearance.shadowColor = UIColor.white.withAlphaComponent(0.1)
        
        // Selected tab item - bright white with enhanced visibility
        tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: .bold),
            .strokeColor: UIColor.black.withAlphaComponent(0.3),
            .strokeWidth: -1.0
        ]
        
        // Normal tab item - semi-transparent white with subtle outline
        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.8)
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .strokeColor: UIColor.black.withAlphaComponent(0.2),
            .strokeWidth: -0.5
        ]
        
        // Apply globally to all tab bars
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        
        // Set global tint colors for enhanced visibility
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(0.75)
        
        // Add subtle background tint for better icon visibility
        UITabBar.appearance().barTintColor = UIColor.black.withAlphaComponent(0.1)
        
        // Setup navigation bar appearance globally
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
}
