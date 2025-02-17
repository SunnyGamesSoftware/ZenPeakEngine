
import Foundation
import UIKit
import UserNotifications
import AppsFlyerLib

extension ZenPeakEngine: AppsFlyerLibDelegate {
    
    public func zenMinimalAFParse(_ data: [AnyHashable: Any]) {
        if let firstKey = data.keys.first {
            print("zenMinimalAFParse -> first key: ")
        } else {
            print("zenMinimalAFParse -> empty dictionary")
        }
    }
    
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        let afDataJson   = try! JSONSerialization.data(withJSONObject: conversionInfo, options: .fragmentsAllowed)
        let afDataString = String(data: afDataJson, encoding: .utf8) ?? "{}"
        
        print("dglvbzx2668")
        
        let finalJson = """
        {
            "\(appsDataString)": \(afDataString),
            "\(appsIDString)": "\(AppsFlyerLib.shared().getAppsFlyerUID() ?? "")",
            "\(langString)": "\(Locale.current.languageCode ?? "")",
            "\(tokenString)": "\(deviceToken)"
        }
        """
        
        checkDataWith(code: finalJson) { outcome in
            switch outcome {
            case .success(let msg):
                self.sendNotification(name: "ZenPeakNotification", message: msg)
            case .failure:
                self.sendNotificationError(name: "ZenPeakNotification")
            }
        }
    }
    
    public func zenPrintRandomDebug() {
        let rnd = Int.random(in: 1...100)
        print("zenPrintRandomDebug -> random: \(rnd)")
    }
    
    public func StartAF(appID: String, devKey: String) {
        AppsFlyerLib.shared().appleAppID                   = appID
        AppsFlyerLib.shared().appsFlyerDevKey              = devKey
        AppsFlyerLib.shared().delegate                     = self
        AppsFlyerLib.shared().disableAdvertisingIdentifier = true
        print("111124f")
    }
    
    public func onConversionDataFail(_ error: any Error) {
        self.sendNotificationError(name: "ZenPeakNotification")
    }
    
    @objc func handleSessionDidBecomeActive() {
        if !self.hasSessionStarted {
            AppsFlyerLib.shared().start()
            self.hasSessionStarted = true
        }
    }

    public func requestZenNotifications(app: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, err in
            if granted {
                DispatchQueue.main.async {
                    app.registerForRemoteNotifications()
                }
                print("dfdafhmcvnx2")
                
            } else {
                print("requestZenNotifications -> user denied notification perms.")
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSessionDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    internal func sendNotification(name: String, message: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": message]
            )
        }
    }
    
    internal func sendNotificationError(name: String) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name(name),
                object: nil,
                userInfo: ["notificationMessage": "Error occurred"]
            )
        }
    }
    
    public func zenInspectAFDict(_ dict: [AnyHashable: Any]) {
        print("zenInspectAFDict -> items: \(dict.count)")
    }
    
    public func zenIsSessionActive() -> Bool {
        return hasSessionStarted
    }
}
