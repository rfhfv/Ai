//
//  VideoGenerationPresenter.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

protocol VideoGenerationViewProtocol: AnyObject {
    func configure(title: String, images: [UIImage])
}

protocol VideoGenerationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didTapCreate()
    func didUploadImage(_ image: UIImage)
    func didSelectFormat(_ format: String)
    func didSelectQuality(_ quality: String)
}

final class VideoGenerationPresenter {

    weak var view: VideoGenerationViewProtocol?
    private let coordinator: VideoGenerationCoordinatorProtocol
    private let templateTitle: String
    private let templateImages: [UIImage]

    private var selectedFormat = "16:9"
    private var selectedQuality = "1080p"
    private var uploadedImage: UIImage?

    init(
        coordinator: VideoGenerationCoordinatorProtocol,
        title: String,
        images: [UIImage]
    ) {
        self.coordinator = coordinator
        self.templateTitle = title
        self.templateImages = images
    }
}

extension VideoGenerationPresenter: VideoGenerationPresenterProtocol {

    func viewDidLoad() {
        view?.configure(title: templateTitle, images: templateImages)
    }

    func didTapBack() { coordinator.back() }

    func didUploadImage(_ image: UIImage) {
        uploadedImage = image
    }

    func didSelectFormat(_ format: String) {
        selectedFormat = format
    }

    func didSelectQuality(_ quality: String) {
        selectedQuality = quality
    }

    func didTapCreate() {
        coordinator.showResult()
    }
}
