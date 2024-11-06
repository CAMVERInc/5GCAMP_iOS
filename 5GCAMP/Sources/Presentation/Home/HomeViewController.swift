//
//  HomeViewController.swift
//  5GCAMP
//
//  Created by WONJI HA on 11/4/24.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    let urlManager = URLManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebView()
        print("홈화면 새로고침 됨.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello CAMVER\nI'm Home")
        
    }
    
    private func loadWebView() {
        if let request = urlManager.mainURLRequest() {
            webView.load(request)
            print("웹뷰 로딩")
        } else {
            print("URL 로딩 실패")
        }
    }
    
    private func reloadWebView() {
        webView.reload()
        print("웹리로드")
    }
}

