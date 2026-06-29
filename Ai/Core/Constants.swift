//
//  Constants.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

enum Constants {
    static let baseURL = "https://nebulaapps.site"
    static let appId = "com.test.test"
    static let userId = "test-user-001"
    
    static var apiToken: String {
        Bundle.main.infoDictionary?["API_TOKEN"] as? String ?? ""
    }
}
