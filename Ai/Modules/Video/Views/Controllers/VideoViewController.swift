//
//  VideoViewController.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import UIKit

final class VideoViewController: UIViewController {
    
    private let presenter: VideoPresenterProtocol
    private let videoView = VideoView()
    
    // MARK: - Init
    
    init(presenter: VideoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = videoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private 
    
    private func setupDelegates() {
        videoView.delegate = self
    }
}

extension VideoViewController: VideoViewDelegate {
    func didSelectFilter(_ filter: VideoFilter) { }
    
    func didSelectVideo(at index: Int) {
        presenter.didSelectVideo(at: index)
    }
    
    func didTapBack() {
        presenter.didTapBack()
    }
    
    func didTapHistory() { }
}

extension VideoViewController: VideoViewProtocol {
    
    func showPhotoAccessDeniedAlert() {
        let alert = UIAlertController(
            title: Strings.Video.alertTitle,
            message: Strings.Video.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Strings.Video.cancelText, style: .cancel))
        alert.addAction(UIAlertAction(title: Strings.Video.allowText , style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        
        alert.overrideUserInterfaceStyle = .dark
        navigationController?.present(alert, animated: true)
    }
    
    func showError(_ message: String) { }
}
