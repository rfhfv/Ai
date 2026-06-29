//
//  VideoGenerationViewController.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit
import PhotosUI

final class VideoGenerationViewController: UIViewController {
    
    let detailView = VideoGenerationView()
    private let presenter: VideoGenerationPresenterProtocol
    
    // MARK: - Init
    
    init(presenter: VideoGenerationPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupDelegates()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupDelegates() {
        detailView.delegate = self
    }
}

// MARK: - VideoGenerationViewProtocol

extension VideoGenerationViewController: VideoGenerationViewProtocol {
    func configure(title: String, images: [UIImage]) {
        detailView.configure(title: title, images: images)
    }
}

// MARK: - VideoGenerationViewDelegate

extension VideoGenerationViewController: VideoGenerationViewDelegate {
    
    func didTapBack() {
        presenter.didTapBack()
    }
    
    func didTapCreate() {
        presenter.didTapCreate()
    }
    
    func didTapUploadImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func didTapFormat() {
        let sheet = OptionsBottomSheet(
            options: ["16:9", "9:16", "1:1", "4:3"],
            selected: "16:9"
        ) { [weak self] value in
            self?.detailView.setFormat(value)
            self?.presenter.didSelectFormat(value)
        }
        present(sheet, animated: false)
    }
    
    func didTapQuality() {
        let sheet = OptionsBottomSheet(
            options: ["540p", "720p", "1080p", "4K"],
            selected: "1080p"
        ) { [weak self] value in
            self?.detailView.setQuality(value)
            self?.presenter.didSelectQuality(value)
        }
        present(sheet, animated: false)
    }
    
    // MARK: - Private
    
    private func showOptionsAlert(title: String, options: [String], onSelect: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        options.forEach { option in
            alert.addAction(UIAlertAction(title: option, style: .default) { _ in
                onSelect(option)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension VideoGenerationViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        
        detailView.showUploadLoading()
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            DispatchQueue.main.async {
                if let image = object as? UIImage {
                    self?.detailView.showUploadedImage(image)
                    self?.presenter.didUploadImage(image)
                }
            }
        }
    }
}
