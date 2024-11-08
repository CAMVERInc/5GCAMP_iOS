//
//  HomeViewController.swift
//  5GCAMP
//
//  Created by WONJI HA on 11/4/24.
//

import UIKit
import WebKit
import SafariServices

final class HomeViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    private let homeViewModel = HomeViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.loadWebView()
        print("홈화면 새로고침 됨.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupWebView()
        print("Hello CAMVER\nI'm Home")
    }
    
    private func setupBindings() {
        homeViewModel.webViewRequest.bind { [weak self] request in
            if let request = request {
                self?.webView.load(request)
            }
        }
        
        homeViewModel.errorMessage.bind { [weak self] message in
            if let message = message {
                self?.errorAlert(message: message)
            }
        }
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        
    }
    
    private func errorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {
            (action) in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let scheme = url.scheme else {
            print("Allowing navigation (no URL or scheme)")
            decisionHandler(.allow)
            return
        }
        
        print("Navigating to: \(url.absoluteString)")
        print("Scheme: \(scheme)")
        
        switch scheme {
        case "tel":
            handleTelURL(url: url)
            decisionHandler(.cancel)
        case "http", "https":
            handleWebURL(url: url, decisionHandler: decisionHandler)
        default:
            print("Allowing navigation for other schemes")
            decisionHandler(.allow)
        }
    }
    
    private func handleTelURL(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print("Opening tel URL externally")
    }
    
    private func handleWebURL(url: URL, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if url.host?.contains(homeViewModel.loadMainURL()) == true {
            print("Allowing navigation for internal domain")
            decisionHandler(.allow)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Opening http/https URL externally")
            decisionHandler(.cancel)
        }
    }
}

extension HomeViewController: TabBarProtocol {
    func reloadView() {
        homeViewModel.loadWebView()
        print("리로드됨.")
    }
}
