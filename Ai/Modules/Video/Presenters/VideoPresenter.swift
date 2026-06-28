//
//  VideoPresenter.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit
import Photos

protocol VideoPresenterProtocol: AnyObject {
    func didTapBack()
    func didSelectVideo(at index: Int)
    func didSelectFilter(_ filter: VideoFilter)
}

protocol VideoViewProtocol: AnyObject {
    func showError(_ message: String)
    func showPhotoAccessDeniedAlert()
}

final class VideoPresenter {
    
    weak var view: VideoViewProtocol?
    
    private let coordinator: VideoCoordinatorProtocol
    
    private let images: [UIImage] = {
        let img = [UIImage(named: Images.Video.defaultImageTwo),
                   UIImage(named: Images.Video.defaultImageOne),
                   UIImage(named: Images.Video.defaultImageTwo),
                   UIImage(named: Images.Video.defaultImageTwo)]
        return img.compactMap { $0 }
    }()
    
    // MARK: - Init
    
    init(coordinator: VideoCoordinatorProtocol) {
        self.coordinator = coordinator
    }
}

// MARK: - VideoPresenterProtocol

extension VideoPresenter: VideoPresenterProtocol {
    func didTapBack() {
        coordinator.backToMain()
    }
    
    func didSelectVideo(at index: Int) {
        requestPhotoAccess()
    }
    
    func didSelectFilter(_ filter: VideoFilter) { }
    
    private func requestPhotoAccess() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized:
            coordinator.showVideoDetail(title: "Clay Fool", images: images)
            
        case .notDetermined, .limited:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async { [weak self] in
                    if newStatus == .authorized {
                        self?.coordinator.showVideoDetail(title: "Clay Fool", images: self?.images ?? [])
                    } else {
                        self?.view?.showPhotoAccessDeniedAlert()
                    }
                }
            }
            
        case .restricted, .denied:
            DispatchQueue.main.async { [weak self] in
                self?.view?.showPhotoAccessDeniedAlert()
            }
            
        @unknown default:
            break
        }
    }
}
