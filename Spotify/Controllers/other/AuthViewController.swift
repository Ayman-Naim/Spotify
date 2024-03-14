//
//  AuthViewController.swift
//  Spotify
//
//  Created by ayman on 11/03/2024.
//

import UIKit
import WebKit
class AuthViewController: UIViewController,WKNavigationDelegate {

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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    

   

}
