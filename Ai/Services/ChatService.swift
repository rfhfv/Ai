//
//  ChatService.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

protocol ChatServiceProtocol {
    func sendMessage(chatId: String, text: String, completion: @escaping (Result<SendDolaMessageResponse, NetworkError>) -> Void)
    func getMessages(chatId: String, completion: @escaping (Result<[DolaMessageResponse], NetworkError>) -> Void)
    func getChats(completion: @escaping (Result<[DolaChatResponse], NetworkError>) -> Void)
}

final class ChatService: ChatServiceProtocol {
    
    private let network: NetworkManagerProtocol
    
    init(network: NetworkManagerProtocol = NetworkManager.shared) {
        self.network = network
    }
    
    func sendMessage(chatId: String, text: String, completion: @escaping (Result<SendDolaMessageResponse, NetworkError>) -> Void) {
        let body = SendDolaMessageRequest(message: text, personaId: nil, additionalPrompt: nil)
        network.request(endpoint: .sendMessage(chatId: chatId), body: body, completion: completion)
    }
    
    func getMessages(chatId: String, completion: @escaping (Result<[DolaMessageResponse], NetworkError>) -> Void) {
        network.request(endpoint: .getMessages(chatId: chatId), body: nil, completion: completion)
    }
    
    func getChats(completion: @escaping (Result<[DolaChatResponse], NetworkError>) -> Void) {
        network.request(endpoint: .getChats, body: nil, completion: completion)
    }
}
