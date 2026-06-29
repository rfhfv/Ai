//
//  ChatMessage.swift
//  Ai
//
//  Created by admin on 25.06.2026.
//

import Foundation

enum MessageRole {
    case user
    case assistant
    case loading
}

struct ChatMessage {
    let id: UUID
    let role: MessageRole
    let text: String
    
    init(role: MessageRole, text: String = "") {
        self.id = UUID()
        self.role = role
        self.text = text
    }
}
