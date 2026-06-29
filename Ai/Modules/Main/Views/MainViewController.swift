//
//  MainViewController.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let presenter: MainPresenterProtocol
    private let mainView = MainView()
    
    // MARK: - Init
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
    }
}

// MARK: - MainViewDelegate

extension MainViewController: MainViewDelegate {
    func showPaywall() {
        PaywallManager.shared.present(from: self)
    }
    
    func didTapSearch() {
        presenter.didTapChat()
    }
    
    func didTapVideoCard() {
        presenter.didTapVideo()
    }
}
