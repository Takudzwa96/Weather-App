import SwiftUI

/// SplashScreenView displays an animated splash screen when the app launches.
struct SplashScreenView: View {
    @State private var animate = false
    var onFinish: (() -> Void)?
    @State private var gradientAngle: Double = 0 
    
    var body: some View {
        ZStack {
            // Animated gradient background
            AngularGradient(
                gradient: Gradient(colors: [
                    Color(red: 39/255, green: 139/255, blue: 227/255),
                    Color.purple,
                    Color.blue,
                    Color(red: 0, green: 1, blue: 1),
                    Color(red: 39/255, green: 139/255, blue: 227/255)
                ]),
                center: .center,
                angle: .degrees(gradientAngle)
            )
            .ignoresSafeArea()
            .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: gradientAngle)

            // Subtle animated circles for depth
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -180)
                .blur(radius: 1)
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 180, height: 180)
                .offset(x: 120, y: 200)
                .blur(radius: 1)

            VStack(spacing: 0) {
                ZStack {
                    // Soft glow behind the icon
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 140, height: 140)
                        .blur(radius: 8)
                    Image(systemName: "cloud.sun.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .shadow(color: Color.blue.opacity(0.4), radius: 16, x: 0, y: 8)
                        .scaleEffect(animate ? 1.1 : 0.8)
                        .opacity(animate ? 1 : 0.7)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
                }
                Text("Weather App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 2)
                    .padding(.top, 24)
            }
        }
        .onAppear {
            animate = true
            withAnimation {
                gradientAngle = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onFinish?()
            }
        }
    }
}

#Preview {
    SplashScreenView()
} 
