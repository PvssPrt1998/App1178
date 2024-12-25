import SwiftUI

struct Tab: View {
    
    @EnvironmentObject var source: Source
    @State var tabScreen: TabScreen = .tracker
    @State var showSettings = false
    @State var showDeleteRecipe = false
    @State var showPrepareRecipe = false
    
    var body: some View {
        ZStack {
            switch tabScreen {
            case .tracker:
                TrackerView()
            case .recipe:
                Recipes(showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
            }
            
            HStack(spacing: 0) {
                Image(systemName: "dial.high.fill")
                    .font(.system(size: 17, weight: .regular))
                    .frame(width: 28, height: 28)
                    .foregroundColor(tabScreen == .tracker && !showSettings ? .cPrimary : .cSecondary.opacity(0.44))
                    .onTapGesture {
                        tabScreen = .tracker
                    }
                    .frame(maxWidth: .infinity)
                Image(tabScreen == .recipe && !showSettings ? "ovenTabSelected" : "ovenTab")
                    .resizable()
                    .scaledToFit()
                    .padding(3)
                    .frame(width: 28, height: 28)
                    .foregroundColor(tabScreen == .recipe && !showSettings ? .cPrimary : .cSecondary.opacity(0.44))
                    .onTapGesture {
                        tabScreen = .recipe
                    }
                    .frame(maxWidth: .infinity)
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .regular))
                    .frame(width: 28, height: 28)
                    .foregroundColor(showSettings ? .cPrimary : .cSecondary.opacity(0.44))
                    .onTapGesture {
                        showSettings = true
                    }
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 12.5)
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(height: 83)
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            
            if showSettings {
                SettingsView {
                    showSettings = false
                }
            }
            if showDeleteRecipe {
                DeleteActionSheet {
                    guard let recipe = source.recipeForDelete else { return }
                    source.remove(recipe)
                    showDeleteRecipe = false
                } cancelAction: {
                    showDeleteRecipe = false
                }
            }
            if showPrepareRecipe {
                PrepareView(currentTime: source.recipeForPrepare!.currentTime, totalTime: source.recipeForPrepare!.time * 60) {
                    source.finishPrepareRecipe()
                    showPrepareRecipe = false
                } stopAction: {
                    source.prepareRecipeStop()
//                    print("stop")
//                    source.prepareRecipeStop()
                    showPrepareRecipe = false
                } cancelAction: {
                    source.prepareRecipeCancel()
                    showPrepareRecipe = false
                }

            }
        }
        .onAppear {
            AppDelegate.orientationLock = .portrait
        }
    }
}

#Preview {
    Tab()
        .environmentObject(Source())
}

enum TabScreen {
    case tracker
    case recipe
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
