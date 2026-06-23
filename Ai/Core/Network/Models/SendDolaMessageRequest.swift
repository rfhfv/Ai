//
//  SendDolaMessageRequest.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

struct SendDolaMessageRequest: Encodable {
    let message: String
    let personaId: Int?
    let additionalPrompt: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case personaId = "persona_id"
        case additionalPrompt = "additional_prompt"
    }
}
