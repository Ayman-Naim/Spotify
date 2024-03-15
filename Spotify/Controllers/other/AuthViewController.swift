//
//  AuthViewController.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import UIKit
import WebKit
class AuthViewController: UIViewController,WKNavigationDelegate {
    public var completionHandler: ((Bool)->Void)?
    private let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        guard let url  = AuthManger.shared.signInURL else{ return }
        webView.load(URLRequest(url: url))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        // exchange the code for access token
        let components = URLComponents(string: url.absoluteString)
        guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true
        print("code\(code)")
        
        AuthManger.shared.exchangeCodeForToken(code: code) { [weak self ]succses  in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(succses)
            }
            
        }
    }
   

}
