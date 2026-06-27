//
//  ChatHistoryCoordinator.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

protocol ChatHistoryCoordinatorProtocol: AnyObject {
    func back()
}

final class ChatHistoryCoordinator: ChatHistoryCoordinatorProtocol {
    
    private let navigationController: UINavigationController
    private var chatCoordinator: ChatCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = ChatHistoryPresenter(coordinator: self)
        let vc = ChatHistoryViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
