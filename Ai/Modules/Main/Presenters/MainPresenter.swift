//
//  MainPresenterProtocol.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func didTapChat()
    func didTapVideo()
}

final class MainPresenter {
    
    private let coordinator: MainCoordinator
    
    // MARK: - Init
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func didTapChat() {
        coordinator.showChat()
    }
    
    func didTapVideo() {
        coordinator.showVideo()
    }
}
