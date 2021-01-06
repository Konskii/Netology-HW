//
//  RepoWebViewController.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 06.01.2021.
//  Copyright © 2021 Артём Скрипкин. All rights reserved.
//

import UIKit
import WebKit

class RepoWebViewController: UIViewController, WKUIDelegate {
    //MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    //MARK: - Methods
    public func loadRepo(url: URL) {
        let request = URLRequest(url: url)
        injectJavaScript()
        webView.load(request)
    }
    
    private func injectJavaScript() {
        let source = "document.body.style.backgroundColor = \"#e1ff59\";"
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webView.reload()
    }
    
    //MARK: - LifeCycle
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
