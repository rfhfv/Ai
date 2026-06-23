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

final class MainPresenter: MainPresenterProtocol {
    
    private let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func didTapChat() {
        coordinator.showChat()
    }
    
    func didTapVideo() {
        coordinator.showVideo()
    }
}
