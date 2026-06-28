//
//  VideoView.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import UIKit

protocol VideoViewDelegate: AnyObject {
    func didTapBack()
    func didTapHistory()
    func didSelectFilter(_ filter: VideoFilter)
    func didSelectVideo(at index: Int)
}

final class VideoView: UIView {
    
    private enum Constants {
        static let topBarHSize: CGFloat = 129
        static let filterCollectionViewHSize: CGFloat = 44
        static let filterCellHeight: CGFloat = 30
        static let previewCellHeight: Int = 232
    }

    weak var delegate: VideoViewDelegate?
    private(set) var selectedFilterIndex: Int = 0
    private var didInvalidateLayout = false
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Insets.s8
        layout.minimumLineSpacing = Insets.s8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(
            top: 0,
            left: Insets.s12,
            bottom: 0,
            right: Insets.s12
        )
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Insets.s16
        layout.minimumLineSpacing = Insets.s16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(
            top: Insets.s16,
            left: Insets.s16,
            bottom: Insets.s16,
            right: Insets.s16
        )
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(VideoGridCell.self, forCellWithReuseIdentifier: VideoGridCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Top Bar
    
    private let topBar: UIView = {
        let v = UIView()
        v.backgroundColor = .cmChocolate
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Common.backImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let avatarIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.Video.aiVideoImage)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Video.title, font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let historyButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: Images.Chat.historyImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !didInvalidateLayout, gridCollectionView.bounds.width > 0 else { return }
        didInvalidateLayout = true
        gridCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Setup UI

private extension VideoView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    func setupViews() {
        backgroundColor = .black
        topBar.addSubviews(backButton, avatarIconView, titleLabel, historyButton)
        addSubviews(filterCollectionView, gridCollectionView, topBar)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(didTapHistoryButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBack()
    }
    
    @objc func didTapHistoryButton() {
        delegate?.didTapHistory()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Constants.topBarHSize),
            
            backButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: Insets.s80),
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: Insets.s16),
            backButton.widthAnchor.constraint(equalToConstant: Insets.s24),
            
            avatarIconView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: Insets.s32),
            avatarIconView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            avatarIconView.widthAnchor.constraint(equalToConstant: Insets.s32),
            avatarIconView.heightAnchor.constraint(equalToConstant: Insets.s32),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarIconView.trailingAnchor, constant: Insets.s12),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            historyButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -Insets.s16),
            historyButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            historyButton.widthAnchor.constraint(equalToConstant: Insets.s24),
            
            filterCollectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: Insets.s24),
            filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: Constants.filterCollectionViewHSize),
            
            gridCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: Insets.s12),
            gridCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension VideoView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView === filterCollectionView ? VideoFilter.allCases.count : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FilterCell.reuseId,
                for: indexPath
            ) as? FilterCell else { return UICollectionViewCell() }
            
            let filter = VideoFilter.allCases[indexPath.item]
            cell.configure(title: filter.title, isSelected: indexPath.item == selectedFilterIndex)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VideoGridCell.reuseId,
            for: indexPath
        ) as? VideoGridCell else { return UICollectionViewCell() }
        
        cell.configure(title: Strings.Video.previewTitle, image: UIImage(named: Images.Video.defaultImageOne))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension VideoView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === filterCollectionView {
            selectedFilterIndex = indexPath.item
            filterCollectionView.reloadData()
            delegate?.didSelectFilter(VideoFilter.allCases[indexPath.item])
        } else {
            delegate?.didSelectVideo(at: indexPath.item)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VideoView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView === filterCollectionView {
            let title = VideoFilter.allCases[indexPath.item].title
            let textWidth = (title as NSString).size(
                withAttributes: [.font: Typography.r16.font]
            ).width
            return CGSize(
                width: textWidth + 32,
                height: Constants.filterCellHeight
            )
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let totalPadding = 16 * 2 + 16 
        let cellWidth = (Int(screenWidth) - totalPadding) / 2
        return CGSize(width: cellWidth, height: Constants.previewCellHeight)
    }
}
