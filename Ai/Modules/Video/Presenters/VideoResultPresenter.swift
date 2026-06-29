//
//  VideoResultPresenter.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit
import Photos

protocol VideoResultViewProtocol: AnyObject {
    func showLoadingState()
    func showResultState(with model: VideoGenerationModel)
    func showSavedToGallery()
    func showError(_ message: String)
}

protocol VideoResultPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapShare()
    func didTapDownload()
    func didTapBack()
    func didTapReplace()
    func didTapPlay()
}

// MARK: - Presenter

final class VideoResultPresenter {
    
    weak var view: VideoResultViewProtocol?
    weak var viewController: UIViewController?
    
    private let coordinator: VideoResultCoordinatorProtocol
    private var generationWorkItem: DispatchWorkItem?
    private var currentModel: VideoGenerationModel?
    
    private var mockVideoURL: URL? {
        URL(string: "file://video.mp4")
    }
    
    private let mockThumbnail = UIImage(named: Images.Result.resultImage) ?? UIImage()
    
    // MARK: - Init
    
    init(coordinator: VideoResultCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

// MARK: - VideoResultPresenterProtocol

extension VideoResultPresenter: VideoResultPresenterProtocol {
    
    func viewDidLoad() {
        startGeneration()
    }
    
    func didTapBack() {
        generationWorkItem?.cancel()
        coordinator.back()
    }
    
    func didTapReplace() {
        view?.showLoadingState()
        startGeneration()
    }
    
    func didTapPlay() {
        // TODO: воспроизведение видео
    }
    
    func didTapShare() {
        guard let model = currentModel else { return }
        coordinator.showShareSheet(items: [model.videoURL], from: viewController ?? UIViewController())
    }
    
    func didTapDownload() {
        guard let model = currentModel else { return }
        saveToGallery(image: model.thumbnail)
    }
    
    // MARK: - Private
    
    private func startGeneration() {
        generationWorkItem?.cancel()
        
        guard let url = mockVideoURL else { return }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            let model = VideoGenerationModel(
                videoURL: url,
                thumbnail: self.mockThumbnail
            )
            self.currentModel = model
            self.view?.showResultState(with: model)
        }
        generationWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
    }
    
    private func saveToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        view?.showSavedToGallery()
    }
}
