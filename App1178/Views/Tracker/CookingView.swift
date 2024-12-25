import UIKit
import SwiftUI
import WebKit
import Combine

struct CookingAchievementProfile: UIViewRepresentable {
    
    enum URLType {
        case local, `public`
    }
    
    var type: URLType
    var url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        
        let configuration = WKWebViewConfiguration()
        let websiteDataStore = WKWebsiteDataStore.default()
        configuration.websiteDataStore = websiteDataStore
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        if let savedData = UserDefaults.standard.data(forKey: "SavedSkinShowing"),
           let cookies = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, HTTPCookie.self], from: savedData) as? [HTTPCookie] {
            cookies.forEach { cookie in
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                    print("Got: \(cookie.name) = \(cookie.value)")
                }
            }
        }
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let urlValue = url  {
            if let requestUrl = URL(string: urlValue) {
                webView.load(URLRequest(url: requestUrl))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CookingAchievementProfile
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ webView: CookingAchievementProfile) {
            self.parent = webView
        }
        
        deinit {
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//            if let urlStr = navigationAction.request.url?.absoluteString {
//
//            }
//            decisionHandler(.allow, preferences)
            if let savedData = UserDefaults.standard.data(forKey: "SavedSkinShowing"),
               let cookies = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, HTTPCookie.self], from: savedData) as? [HTTPCookie] {
                let dispatchGroup = DispatchGroup()
                cookies.forEach { cookie in
                    dispatchGroup.enter()
                    webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
                        print("GotNext: \(cookie.name) = \(cookie.value)")
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    decisionHandler(.allow, preferences)
                }
                
            } else {
                decisionHandler(.allow, preferences)
            }
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            if let url = webView.url?.absoluteString {
//                if verifyUrl(urlString: url) {
//                    VMCreator.shared.statLine = url
//                    print("URL \n")
//                    print(url)
//                    print("\n")
//                }
//            }
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                let data = try? NSKeyedArchiver.archivedData(withRootObject: cookies, requiringSecureCoding: false)
                UserDefaults.standard.set(data, forKey: "SavedSkinShowing")
            }
        }
        
        func verifyUrl (urlString: String?) -> Bool {
            if let urlString = urlString {
                if let url = NSURL(string: urlString) {
                    return UIApplication.shared.canOpenURL(url as URL)
                }
            }
            return false
        }
    }
}
