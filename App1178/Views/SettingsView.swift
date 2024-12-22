import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @State var offset: CGFloat = 300
    let cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    
                    Divider()
                    
                    Button {
                        SKStoreReviewController.requestReviewInCurrentScene()
                    } label: {
                        Text("Rate App")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    
                    Divider()
                    
                    Button {
                       actionSheet()
                    } label: {
                        Text("Share App")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    
                    Divider()
                    
                    Button {
                        if let url = URL(string: "https://www.termsfeed.com/live/f330b43d-74e9-40ab-931b-352629c08f3a") {
                            openURL(url)
                        }
                    } label: {
                        Text("Usage Policy")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.cPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    
                }
                .background(Color.c234234234)
                .clipShape(.rect(cornerRadius: 14))
                
                Button {
                    withAnimation {
                        offset = 300
                    }
                    cancelAction()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.c234234234)
                        .clipShape(.rect(cornerRadius: 14))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 14, trailing: 8))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: offset)
        }
        .onAppear {
            withAnimation {
                offset = 0
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/us/app/sweet-recipe-tracker-hobby/id6739509131")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    SettingsView(cancelAction: {})
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
