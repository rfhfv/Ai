//
//  VideoCoordinator.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit

protocol VideoCoordinatorProtocol: AnyObject {
    func backToMain()
    func showVideoDetail(title: String, images: [UIImage])
}

final class VideoCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = VideoPresenter(coordinator: self)
        let vc = VideoViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - VideoCoordinatorProtocol

extension VideoCoordinator: VideoCoordinatorProtocol {
    
    func backToMain() {
        navigationController.popViewController(animated: true)
    }
    
    func showVideoDetail(title: String, images: [UIImage]) {
        let coordinator = VideoGenerationCoordinator(navigationController: navigationController)
        let presenter = VideoGenerationPresenter(coordinator: coordinator, title: title, images: images)
        let vc = VideoGenerationViewController(presenter: presenter)
        presenter.view = vc
        navigationController.pushViewController(vc, animated: true)
    }
}
