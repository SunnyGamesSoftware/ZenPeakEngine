
import UIKit
import WebKit
import SwiftUI

extension ZenPeakEngine {

    func showView(with url: String) {
        self.mainWindow = UIWindow(frame: UIScreen.main.bounds)
        let ctrl = CheckController()
        ctrl.errorString = url
        let navC = UINavigationController(rootViewController: ctrl)
        self.mainWindow?.rootViewController = navC
        self.mainWindow?.makeKeyAndVisible()
    }
    
    private func zenReloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("zenReloadView -> simulating a UI reload.")
        }
    }
    
    public class CheckController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
        private var mainErrorsHandler: WKWebView!
        
        @AppStorage("savedData") var savedData: String?
        @AppStorage("statusFlag") var statusFlag: Bool = false
        
        public var errorString: String!
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            
            let config = WKWebViewConfiguration()
            config.preferences.javaScriptEnabled = true
            config.preferences.javaScriptCanOpenWindowsAutomatically = true
            
            let viewportScript = """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
            let userScript = WKUserScript(source: viewportScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            config.userContentController.addUserScript(userScript)
            
            mainErrorsHandler = WKWebView(frame: .zero, configuration: config)
            mainErrorsHandler.isOpaque = false
            mainErrorsHandler.backgroundColor = .white
            mainErrorsHandler.uiDelegate = self
            mainErrorsHandler.navigationDelegate = self
            mainErrorsHandler.allowsBackForwardNavigationGestures = true
            
            view.addSubview(mainErrorsHandler)
            mainErrorsHandler.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainErrorsHandler.topAnchor.constraint(equalTo: view.topAnchor),
                mainErrorsHandler.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                mainErrorsHandler.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mainErrorsHandler.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            loadContent(urlString: errorString)
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if ZenPeakEngine.shared.finalData == nil {
                let finalUrl = webView.url?.absoluteString ?? ""
                ZenPeakEngine.shared.finalData = finalUrl
            }
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.isNavigationBarHidden = true
        }
        
        private func loadContent(urlString: String) {
            guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let urlObj = URL(string: encodedURL) else { return }
            let req = URLRequest(url: urlObj)
            mainErrorsHandler.load(req)
        }
        
        public func webView(_ webView: WKWebView,
                            createWebViewWith configuration: WKWebViewConfiguration,
                            for navigationAction: WKNavigationAction,
                            windowFeatures: WKWindowFeatures) -> WKWebView? {
            let popup = WKWebView(frame: .zero, configuration: configuration)
            popup.navigationDelegate = self
            popup.uiDelegate = self
            popup.allowsBackForwardNavigationGestures = true
            
            mainErrorsHandler.addSubview(popup)
            popup.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popup.topAnchor.constraint(equalTo: mainErrorsHandler.topAnchor),
                popup.bottomAnchor.constraint(equalTo: mainErrorsHandler.bottomAnchor),
                popup.leadingAnchor.constraint(equalTo: mainErrorsHandler.leadingAnchor),
                popup.trailingAnchor.constraint(equalTo: mainErrorsHandler.trailingAnchor)
            ])
            
            return popup
        }
    }
    
    public struct CheckPortalSwiftUI: UIViewControllerRepresentable {
        public var errorDetail: String
        
        
        public init(errorDetail: String) {
            self.errorDetail = errorDetail
        }
        
        public func makeUIViewController(context: Context) -> CheckController {
            let ctrl = CheckController()
            ctrl.errorString = errorDetail
            return ctrl
        }
        
        public func updateUIViewController(_ uiViewController: CheckController, context: Context) {}
    }
    
    private func zenUIMeasure() {
        print("zenUIMeasure -> measuring mainWindow or UI elements.")
    }
    
    
    private func zenCheckNavBack() {
        print("zenCheckNavBack -> checking if can go back in navigation.")
    }
    
}
