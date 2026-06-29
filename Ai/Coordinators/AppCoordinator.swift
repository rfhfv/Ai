//
//  AppCoordinator.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
