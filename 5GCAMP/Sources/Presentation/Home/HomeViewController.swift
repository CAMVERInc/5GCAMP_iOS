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
        print("Navigating to: \(navigationAction.request.url?.absoluteString ?? "unknown")")
        if let url = navigationAction.request.url, let scheme = url.scheme {
            print("Scheme: \(scheme)")
            if scheme == "tel" { // 이동 링크가 전화인 경우
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                print("Opening tel URL externally")
            } else if scheme == "http" || scheme == "https" { // 이동 링크가 외부 링크인 경우 사파리 연결
                if let host = url.host, host.contains(homeViewModel.loadMainURL()) {
                    decisionHandler(.allow)
                    print("Allowing navigation for internal domain")
                } else {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    print("Opening http/https URL externally")
                }
            } else {
                decisionHandler(.allow)
                print("Allowing navigation for other schemes")
            }
        } else {
            decisionHandler(.allow)
            print("Allowing navigation (no URL or scheme)")
        }
    }
}

extension HomeViewController: TabBarProtocol {
    func reloadView() {
        homeViewModel.loadWebView()
        print("리로드됨.")
    }
}
