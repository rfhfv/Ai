//
//  VideoResultCoordinator.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

protocol VideoResultCoordinatorProtocol: AnyObject {
    func back()
    func showShareSheet(items: [Any], from viewController: UIViewController)
}

final class VideoResultCoordinator: Coordinator{
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
}

// MARK: - VideoDetailCoordinatorProtocol

extension VideoResultCoordinator: VideoResultCoordinatorProtocol {
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func showShareSheet(items: [Any], from viewController: UIViewController) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(activity, animated: true)
    }
}
