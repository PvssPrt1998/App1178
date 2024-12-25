import SwiftUI

struct Splash: View {
    
    @EnvironmentObject var source: Source
    @State var value: Double = 0
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Image("loadingBackground")
                .resizable()
                .ignoresSafeArea()
            
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
