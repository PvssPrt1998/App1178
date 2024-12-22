import SwiftUI

struct AchievementCard: View {
    
    let achievement: Achievement
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading ,spacing: 17) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(achievement.description)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.black.opacity(0.3))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 209)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.cSecondary.opacity(0.44))
                    .frame(width: 209, height: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.cPrimary)
                            .frame(width: max(5, CGFloat(209 * achievement.progress)), height: 5)
                        ,alignment: .leading
                    )
                
                HStack(spacing: 17) {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.cPrimary)
                            .frame(width: 16, height: 16)
                    }
                    
                    Text("\(Int(achievement.progress * 100)) %")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.cPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: 209)
            }
            
            Image(achievement.image)
                .resizable()
                .scaledToFit()
                .frame(width: 107, height: 110)
        }
        .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 9))
        .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
    }
}

#Preview {
    AchievementCard(achievement: Achievement(title: "Sugar Flowers", description: "Master the technique of making realistic flowers from sugar paste.", image: "SugarFlowers", progress: 0), action: {})
        .padding()
}
