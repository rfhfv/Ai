//
//  VideoGenerationCoordinator.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

protocol VideoGenerationCoordinatorProtocol: AnyObject {
    func back()
    func showResult()
}

final class VideoGenerationCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showResult()
    }
}

// MARK: - VideoGenerationCoordinatorProtocol

extension VideoGenerationCoordinator: VideoGenerationCoordinatorProtocol {

    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func showResult() {
        let coordinator = VideoResultCoordinator(navigationController: navigationController)
        let presenter = VideoResultPresenter(coordinator: coordinator)
        let viewController = VideoResultViewController(presenter: presenter)
        presenter.view = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
