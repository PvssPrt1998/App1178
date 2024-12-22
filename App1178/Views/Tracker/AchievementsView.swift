import SwiftUI

struct AchievementsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var source: Source
    
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                ScrollView(.vertical) {
                    LazyVStack(spacing: 24) {
                        ForEach(source.achievements, id: \.self) { achievement in
                            AchievementCard(achievement: achievement) {
                                source.makeCurrentAchievement(by: achievement.title)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 90)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        Text("Achievements")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.labelPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .overlay(
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.labelPrimary)
                }
                ,alignment: .leading
            )
            .padding(.horizontal, 16)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(Source())
}
