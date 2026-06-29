//
//  SendDolaMessageResponse.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

struct SendDolaMessageResponse: Decodable {
    let chatId: String
    let assistantMessage: String
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case assistantMessage = "assistant_message"
    }
}
