//
//  ActivityIndicator.swift
//  Weather App
//
//  Created by Takudzwa Raisi on 2025/09/20.
//

import SwiftUI
import UIKit

// UIActivityIndicatorView wrapped in SwiftUI for UIKit integration
struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor?
    
    init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style = .medium, color: UIColor? = nil) {
        self._isAnimating = isAnimating
        self.style = style
        self.color = color
    }
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        if let color = color {
            activityIndicator.color = color
        }
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
