//
//  ChatCoordinator.swift
//  Ai
//
//  Created by admin on 24.06.2026.
//

import UIKit

protocol ChatCoordinatorProtocol {
    func backToMain()
    func showHistory()
}

final class ChatCoordinator: Coordinator {
    
    private var historyCoordinator: ChatHistoryCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = ChatPresenter(coordinator: self, chatId: Strings.Chat.chatId)
        let vc = ChatViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
}

extension ChatCoordinator: ChatCoordinatorProtocol {
    
    func backToMain() {
        navigationController.popViewController(animated: true)
    }
    
    func showHistory() {
        let coordinator = ChatHistoryCoordinator(navigationController: navigationController)
        historyCoordinator = coordinator
        coordinator.start()
    }
}
