//
//  ChatHistoryPresenter.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import Foundation

// MARK: - Protocols

protocol ChatHistoryPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
}

protocol ChatHistoryViewProtocol: AnyObject {
    func showChats(_ sections: [ChatHistorySection])
    func showEmpty()
}

final class ChatHistoryPresenter {
    
    weak var view: ChatHistoryViewProtocol?
    
    private let coordinator: ChatHistoryCoordinatorProtocol
    private let chatService: ChatServiceProtocol
    
    // MARK: - Init
    
    init(
        coordinator: ChatHistoryCoordinatorProtocol,
        chatService: ChatServiceProtocol = ChatService()
    ) {
        self.coordinator = coordinator
        self.chatService = chatService
    }
}

// MARK: - ChatHistoryPresenterProtocol

extension ChatHistoryPresenter: ChatHistoryPresenterProtocol {
    
    func viewDidLoad() {
        loadChats()
    }
    
    func didTapBack() {
        coordinator.back()
    }
}

// MARK: - Private

private extension ChatHistoryPresenter {
    
    func loadChats() {
        chatService.getChats { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chats):
                    if chats.isEmpty {
                        self?.view?.showEmpty()
                    } else {
                        let sections = self?.buildSections(from: chats) ?? []
                        self?.view?.showChats(sections)
                    }
                case .failure(let error):
                    self?.view?.showEmpty()
                }
            }
        }
    }
    
    func buildSections(from chats: [DolaChatResponse]) -> [ChatHistorySection] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let sectionFormatter = DateFormatter()
        sectionFormatter.dateFormat = "MMMM d"
        
        var grouped: [(key: String, order: Date, items: [ChatHistoryItem])] = []
        var seen: [String: Int] = [:]
        
        for chat in chats {
            guard let date = parseDate(chat.updatedAt) else {
                continue
            }
            let day = calendar.startOfDay(for: date)
            
            let sectionTitle: String
            if calendar.isDate(day, inSameDayAs: today) {
                sectionTitle = "Today"
            } else if calendar.isDate(day, inSameDayAs: yesterday) {
                sectionTitle = "Yesterday"
            } else {
                sectionTitle = sectionFormatter.string(from: day)
            }
            
            let item = ChatHistoryItem(
                chatId: chat.chatId,
                preview: chat.lastMessagePreview ?? chat.title ?? "New chat",
                formattedTime: timeFormatter.string(from: date)
            )
            
            if let idx = seen[sectionTitle] {
                grouped[idx].items.append(item)
            } else {
                seen[sectionTitle] = grouped.count
                grouped.append((key: sectionTitle, order: day, items: [item]))
            }
        }
        
        return grouped
            .sorted { $0.order > $1.order }
            .map { ChatHistorySection(title: $0.key, chats: $0.items) }
    }
    
    func parseDate(_ string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: string) { return date }
        
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: string) { return date }
        
        let fallback = DateFormatter()
        fallback.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fallback.date(from: string)
    }
}
