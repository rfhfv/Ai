//
//  DolaMessageResponse.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

struct DolaMessageResponse: Decodable {
    let role: String
    let content: String
    let messageSource: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case role, content
        case messageSource = "message_source"
        case createdAt = "created_at"
    }
}
