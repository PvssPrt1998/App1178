import SwiftUI

struct TrackerView: View {
    @EnvironmentObject var source: Source
    
    @State var showCompleteView = false
    
    @State var selection = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        header
                        statView
                            .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                        currentAchievement
                            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
                    }
                    .padding(.bottom, 90)
                }
                
                if showCompleteView {
                    CompleteView(show: $showCompleteView)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        Text("Tracker")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.labelPrimary)
            .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(
            HStack(spacing: 0) {
                NavigationLink {
                    AchievementsView()
                } label: {
                    Image(systemName: "app.gift.fill")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.cPrimary)
                        .frame(width: 22, height: 22)
                }
            }
            , alignment: .trailing
        )
        .padding(.horizontal, 16)
    }
    
    private var statView: some View {
        VStack(spacing: 24) {
            ZStack {
                Image("cake")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 67)
                
                
                if !source.recipes.filter({$0.state == 0}).isEmpty {
                    Circle()
                        .trim(from: 0, to: cookedValue)
                        .stroke(Color.cYellow, style: StrokeStyle(lineWidth: 9.6, lineCap: .round))
                        .scaleEffect(x: -1)
                        .rotationEffect(.degrees(70))
                        .frame(width: 125, height: 125)
                }
                
                if !source.recipes.filter({$0.state == 1}).isEmpty {
                    Circle()
                        .trim(from: cookedValue, to: cookedValue + inProgressValue)
                        .stroke(Color.cPrimary, style: StrokeStyle(lineWidth: 9.6, lineCap: .round))
                        .scaleEffect(x: -1)
                        .rotationEffect(.degrees(70))
                        .frame(width: 125, height: 125)
                }
                
                if !source.recipes.filter({$0.state == 2}).isEmpty {
                    Circle()
                        .trim(from: cookedValue + inProgressValue, to: 1)
                        .stroke(Color.backgroundGradient1, style: StrokeStyle(lineWidth: 9.6, lineCap: .round))
                        .scaleEffect(x: -1)
                        .rotationEffect(.degrees(70))
                        .frame(width: 125, height: 125)
                } else {
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.backgroundGradient1, style: StrokeStyle(lineWidth: 9.6, lineCap: .round))
                        .scaleEffect(x: -1)
                        .rotationEffect(.degrees(70))
                        .frame(width: 125, height: 125)
                }
            }
            
            statLine
        }
        .padding(EdgeInsets(top: 24, leading: 10, bottom: 24, trailing: 10))
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
    }
    
    private var statLine: some View {
        HStack(spacing: 8) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.cSecondary.opacity(0.44))
                    .frame(width: 92, height: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.cYellow)
                            .frame(width: max(5, (CGFloat(source.recipes.filter({$0.state == 0}).count)/CGFloat(source.recipes.count)) * 92))
                        ,alignment: .leading
                    )
                VStack(spacing: 4) {
                    Text("Cooked")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.cYellow)
                    if source.recipes.isEmpty {
                        Text("0 %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cYellow)
                    } else {
                        Text("\(Int(Double(source.recipes.filter({$0.state == 0}).count) / Double(source.recipes.count) * 100) ) %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cYellow)
                    }
                }
            }
            
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.cSecondary.opacity(0.44))
                    .frame(width: 92, height: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.cPrimary)
                            .frame(width: max(5, CGFloat(source.recipes.filter({$0.state == 1}).count)/CGFloat(source.recipes.count) * 92))
                        ,alignment: .leading
                    )
                VStack(spacing: 4) {
                    Text("In progress")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.cPrimary)
                    if source.recipes.isEmpty {
                        Text("0 %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cPrimary)
                    } else {
                        Text("\(statLineNotCooked) %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cPrimary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.cSecondary.opacity(0.44))
                    .frame(width: 92, height: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.cYellow)
                            .frame(width: max(5, CGFloat(source.recipes.filter({$0.state == 2}).count)/CGFloat(source.recipes.count) * 92))
                        ,alignment: .leading
                    )
                VStack(spacing: 4) {
                    Text("Cooked")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.backgroundGradient1)
                    if source.recipes.isEmpty {
                        Text("0 %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.backgroundGradient1)
                    } else {
                        Text("\(Int(Double(source.recipes.filter({$0.state == 2}).count) / Double(source.recipes.count) * 100) ) %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.backgroundGradient1)
                    }
                }
            }
        }
    }
    
    private var statLineNotCooked: Int {
        Int(Double(source.recipes.filter({$0.state == 1}).count) / Double(source.recipes.count) * 100)
    }
    
    private var cookedValue: CGFloat {
        CGFloat(min(1, CGFloat(source.recipes.filter({$0.state == 0}).count)/CGFloat(source.recipes.count)))
    }
    
    private var inProgressValue: CGFloat {
        CGFloat(min(1, CGFloat(source.recipes.filter({$0.state == 1}).count)/CGFloat(source.recipes.count)))
    }
    
    private var notCookedValue: CGFloat {
        CGFloat(min(1, CGFloat(source.recipes.filter({$0.state == 2}).count)/CGFloat(source.recipes.count)))
    }
    
    private var currentAchievement: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                VStack(alignment: .leading ,spacing: 17) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(source.achievements[source.currentAchievementIndex].title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.labelPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(source.achievements[source.currentAchievementIndex].description)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.black.opacity(0.3))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 209)
                }
                
                Image(source.achievements[source.currentAchievementIndex].image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 107, height: 110)
            }
            
            VStack(spacing: 6) {
                Button {
                    source.achievements[source.currentAchievementIndex].progress = 0.2
                    source.dataManager.saveOrEditAchievement(source.achievements[source.currentAchievementIndex])
                } label: {
                    Text("20 %")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(source.achievements[source.currentAchievementIndex].progress >= 0.2 ? .labelPrimary : .cYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 29)
                        .background(
                            rectangle(reached: source.achievements[source.currentAchievementIndex].progress >= 0.2)
                        )
                }
                .disabled(source.achievements[source.currentAchievementIndex].progress >= 0.2)
                Button {
                    source.achievements[source.currentAchievementIndex].progress = 0.6
                    source.dataManager.saveOrEditAchievement(source.achievements[source.currentAchievementIndex])
                } label: {
                    Text("60 %")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(source.achievements[source.currentAchievementIndex].progress >= 0.6 ? .labelPrimary : .cYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 29)
                        .background(
                            rectangle(reached: source.achievements[source.currentAchievementIndex].progress >= 0.6)
                        )
                }
                .disabled(source.achievements[source.currentAchievementIndex].progress >= 0.6)
                Button {
                    source.achievements[source.currentAchievementIndex].progress = 0.8
                    source.dataManager.saveOrEditAchievement(source.achievements[source.currentAchievementIndex])
                } label: {
                    Text("80 %")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(source.achievements[source.currentAchievementIndex].progress >= 0.8 ? .labelPrimary : .cYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 29)
                        .background(
                            rectangle(reached: source.achievements[source.currentAchievementIndex].progress >= 0.8)
                        )
                }
                .disabled(source.achievements[source.currentAchievementIndex].progress >= 0.8)
                Button {
                    source.achievements[source.currentAchievementIndex].progress = 1
                    source.dataManager.saveOrEditAchievement(source.achievements[source.currentAchievementIndex])
                    showCompleteView = true
                } label: {
                    Text("Complete")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(source.achievements[source.currentAchievementIndex].progress >= 1 ? .labelPrimary : .cYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 29)
                        .background(
                            rectangle(reached: source.achievements[source.currentAchievementIndex].progress >= 1)
                        )
                }
                .disabled(source.achievements[source.currentAchievementIndex].progress >= 1)
                
            }
        }
        .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 9))
        .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
    }
    
    @ViewBuilder private func rectangle(reached: Bool) -> some View {
        if reached {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.cYellow)
        } else {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.cYellow, lineWidth: 1)
        }
    }
    
}

#Preview {
    TrackerView()
        .environmentObject(Source())
}
