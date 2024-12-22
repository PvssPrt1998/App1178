import SwiftUI

struct Splash: View {
    
    @EnvironmentObject var source: Source
    @State var value: Double = 0
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color
                .white
                .ignoresSafeArea()
            
            VStack {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 91, height: 76)
                Text("Sweet Recipe:\nTracker Hobby")
                    .font(.system(size: 34, weight: .black))
                    .foregroundColor(.white)
                    .gradientForeground(colors: [
                        .backgroundGradient1.opacity(0.6),
                        .backgroundGradient2.opacity(0.6),
                        .backgroundGradient3.opacity(0.6)])
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 8) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.cPrimary))
                    .frame(width: 30, height: 30)
                    .scaleEffect(1.5, anchor: .center)
                Text("Status...")
                    .font(.body.weight(.regular))
                    .foregroundColor(.cPrimary)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.white, lineWidth: 4)
                .frame(width: 82, height: 82)
                .rotationEffect(.degrees(value))
                .padding(.top, UIScreen.main.bounds.height * 0.65)
        }
        .onAppear {
            source.load {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    screen = .main
                }
            }
        }
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var splash: Screen = .splash
    
    static var previews: some View {
        Splash(screen: $splash)
            .environmentObject(Source())
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom)
        )
            .mask(self)
    }
}
