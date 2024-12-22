import SwiftUI

struct CompleteView: View {
    
    @EnvironmentObject var source: Source
    
    @Binding var show: Bool
    
    @State var trimValue: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                VStack(spacing: 24) {
                    ZStack {
                        Image(source.achievements[source.currentAchievementIndex].image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 112, height: 112)
                        Circle()
                            .stroke(Color.cSecondary.opacity(0.44), lineWidth: 9)
                            .frame(width: 125, height: 125)
                        Circle()
                            .trim(from: 0, to: trimValue)
                            .stroke(Color.cPrimary, lineWidth: 9)
                            .frame(width: 125, height: 125)
                            .rotationEffect(.degrees(-90))
                    }
                    
                    Text("\(Int(trimValue * 100)) %")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.cPrimary)
                }
                
                VStack(spacing: 4) {
                    Text(source.achievements[source.currentAchievementIndex].title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                    Text(source.achievements[source.currentAchievementIndex].description)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.black.opacity(0.3))
                }
                .frame(width: 194)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 24, leading: 10, bottom: 24, trailing: 10))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
            .padding(.horizontal, 16)
        }
        .onAppear {
            stroke()
        }
    }
    
    private func stroke() {
        if trimValue < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.trimValue += 0.01
                self.stroke()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                show = false
            }
        }
    }
}
//
//#Preview {
//    CompleteView()
//        .environmentObject(Source())
//        .padding()
//}
