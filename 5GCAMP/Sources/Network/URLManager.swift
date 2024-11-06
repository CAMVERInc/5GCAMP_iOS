//
//  URLManager.swift
//  5GCAMP
//
//  Created by WONJI HA on 11/6/24.
//

import Foundation

struct URLManager {
    func mainURLRequest() -> URLRequest? {
        let baseURL = "https://www.5gcamp.com/"
        guard let url = URL(string: baseURL) else {
            print("잘못된 주소")
            return nil
        }
        return URLRequest(url: url)
    }
}
