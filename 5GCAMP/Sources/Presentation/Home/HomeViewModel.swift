//
//  HomeViewModel.swift
//  5GCAMP
//
//  Created by WONJI HA on 11/7/24.
//

import Foundation

final class HomeViewModel {
    private let urlManager: URLManager
    
    var webViewRequest: Observable<URLRequest?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(urlManager: URLManager = URLManager()) {
        self.urlManager = urlManager
    }
    
    func loadWebView() {
        isLoading.value = true
        if let request = urlManager.mainURLRequest() {
            webViewRequest.value = request
            isLoading.value = false
            print("웹뷰 로딩")
        } else {
            errorMessage.value = "URL 로딩 실패"
            isLoading.value = false
        }
    }
}
