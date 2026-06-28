//
//  VideoResultViewController.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class VideoResultViewController: UIViewController {

    // MARK: - Properties

    private let presenter: VideoResultPresenterProtocol
    private let resultView = VideoResultView()

    // MARK: - Init

    init(presenter: VideoResultPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = resultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        resultView.delegate = self
        (presenter as? VideoResultPresenter)?.viewController = self
        presenter.viewDidLoad()
    }
}

// MARK: - VideoResultViewDelegate

extension VideoResultViewController: VideoResultViewDelegate {
    func didTapBack() { presenter.didTapBack() }
    func didTapShare() { presenter.didTapShare() }
    func didTapDownload() { presenter.didTapDownload() }
    func didTapReplace() { presenter.didTapReplace() }
    func didTapPlay() { presenter.didTapPlay() }
}

// MARK: - VideoResultViewProtocol

extension VideoResultViewController: VideoResultViewProtocol {
    func showLoadingState() { resultView.showLoadingState() }
    func showResultState(with model: VideoGenerationModel) { resultView.showResultState(with: model) }
    func showSavedToGallery() { resultView.showSavedToGallery() }
    func showError(_ message: String) { resultView.showError(message) }
}
