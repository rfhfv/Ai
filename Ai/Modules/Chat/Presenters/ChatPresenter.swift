//
//  ChatPresenter.swift
//  Ai
//
//  Created by admin on 24.06.2026.
//

import Foundation

protocol ChatPresenterProtocol: AnyObject {
    func didTapBack()
    func sendMessage(text: String)
    func viewDidLoad()
    func didTapHistory()
}

protocol ChatViewProtocol: AnyObject {
    func appendMessage(_ message: ChatMessage)
    func replaceLastMessage(with message: ChatMessage)
    func showError(_ text: String)
}

final class ChatPresenter {
    
    weak var view: ChatViewProtocol?
    
    private let coordinator: ChatCoordinatorProtocol
    private let chatService: ChatServiceProtocol
    private let chatId: String
    
    // MARK: - Init
    
    init(
        coordinator: ChatCoordinatorProtocol,
        chatService: ChatServiceProtocol = ChatService(),
        chatId: String
    ) {
        self.coordinator = coordinator
        self.chatService = chatService
        self.chatId = chatId
    }
}

// MARK: - ChatPresenterProtocol

extension ChatPresenter: ChatPresenterProtocol {
    
    func viewDidLoad() {
        loadHistory()
    }
    
    func didTapBack() {
        coordinator.backToMain()
    }
    
    func didTapHistory() {
        coordinator.showHistory()
    }
    
    func sendMessage(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let userMessage = ChatMessage(role: .user, text: trimmed)
        view?.appendMessage(userMessage)
        
        let loadingMessage = ChatMessage(role: .loading)
        view?.appendMessage(loadingMessage)
        
        chatService.sendMessage(chatId: chatId, text: trimmed) { [weak self] result in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let aiMessage = ChatMessage(role: .assistant, text: response.assistantMessage)
                    self.view?.replaceLastMessage(with: aiMessage)
                    
                case .failure(let error):
                    let errorMessage = ChatMessage(role: .assistant, text: Strings.Chat.errorText)
                    self.view?.replaceLastMessage(with: errorMessage)
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func loadHistory() {
        chatService.getMessages(chatId: chatId) { [weak self] result in
            DispatchQueue.main.async {
                guard case .success(let messages) = result else { return }
                messages.forEach { response in
                    let role: MessageRole = response.role == "user" ? .user : .assistant
                    let message = ChatMessage(role: role, text: response.content)
                    self?.view?.appendMessage(message)
                }
            }
        }
    }
}
