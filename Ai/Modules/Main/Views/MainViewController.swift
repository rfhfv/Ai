//
//  MainViewController.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setTitle("Chat", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var videoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Video", for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(didTapVideoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension MainViewController {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(chatButton)
        view.addSubview(videoButton)
    }
    
    @objc private func didTapChatButton() {
        presenter.didTapChat()
    }
    
    @objc private func didTapVideoButton() {
        presenter.didTapVideo()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            chatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            chatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            chatButton.heightAnchor.constraint(equalToConstant: 60),
            chatButton.widthAnchor.constraint(equalToConstant: 100),
            
            videoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            videoButton.heightAnchor.constraint(equalToConstant: 60),
            videoButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
