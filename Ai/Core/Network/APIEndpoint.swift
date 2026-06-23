//
//  APIEndpoint.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

enum APIEndpoint {
    case sendMessage(chatId: String)
    case getMessages(chatId: String)
    case getChats
    
    var path: String {
        switch self {
        case .sendMessage(let chatId): return "/dola/chats/\(chatId)/messages"
        case .getMessages(let chatId): return "/dola/chats/\(chatId)/messages"
        case .getChats: return "/dola/chats"
        }
    }
    
    var method: String {
        switch self {
        case .sendMessage: return "POST"
        case .getMessages, .getChats: return "GET"
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: Constants.baseURL + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: Constants.userId),
            URLQueryItem(name: "app_id", value: Constants.appId),
        ]
        return components?.url
    }
}
