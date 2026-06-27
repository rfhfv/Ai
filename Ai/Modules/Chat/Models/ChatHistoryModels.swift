//
//  ChatHistoryModels.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import Foundation

struct ChatHistoryItem {
    let chatId: String
    let preview: String
    let formattedTime: String
}

struct ChatHistorySection {
    let title: String
    let chats: [ChatHistoryItem]
}
