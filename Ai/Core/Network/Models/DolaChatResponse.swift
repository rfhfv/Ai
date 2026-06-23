//
//  DolaChatResponse.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

struct DolaChatResponse: Decodable {
    let chatId: String
    let title: String?
    let personaId: Int?
    let updatedAt: String
    let lastMessagePreview: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case chatId = "chat_id"
        case personaId = "persona_id"
        case updatedAt = "updated_at"
        case lastMessagePreview = "last_message_preview"
    }
}
