//
//  ChatCoordinator.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func showChat()
    func showVideo()
}

final class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    private var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = MainPresenter(coordinator: self)
        let vc = MainViewController(presenter: presenter)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showChat() {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }
    
    func showVideo() {
        let vc = VideoViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
