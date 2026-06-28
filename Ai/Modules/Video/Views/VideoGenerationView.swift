//
//  VideoGenerationView.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

protocol VideoGenerationViewDelegate: AnyObject {
    func didTapBack()
    func didTapUploadImage()
    func didTapCreate()
    func didTapFormat()
    func didTapQuality()
}

final class VideoGenerationView: UIView {
    
    private enum Constants {
        static let topBarHSize: CGFloat = 100
        static let carouselCollectionViewHSize: CGFloat = 311
        static let uploadButtonSize: CGFloat = 100
        static let uploadPlusIconSize: CGFloat = 32
        static let gradientSpinnerSize: CGFloat = 36
        static let formatRowHSize: CGFloat = 60
        static let separatorHSize: CGFloat = 8
        static let qualityRowHSize: CGFloat = 60
        static let gradientViewHSize: CGFloat = 56
        static let createButtonHSize: CGFloat = 56
        
        static let itemWidth: CGFloat = 343
        static let sizeForItem: CGSize = CGSize(width: 331, height: 311)
    }
    
    weak var delegate: VideoGenerationViewDelegate?
    
    private var templateImages: [UIImage] = []
    private var uploadedImage: UIImage?
    private var didLayout = false
    
    private let uploadBorderLayer = CAGradientLayer()
    private let spinnerGradientLayer = CAGradientLayer()
    private let spinnerMaskLayer = CAShapeLayer()
    
    private let topBar: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Common.backImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Insets.s12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: Insets.s16, bottom: 0, right: Insets.s16)
        cv.decelerationRate = .fast
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TemplatePreviewCell.self, forCellWithReuseIdentifier: TemplatePreviewCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private let uploadButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.layer.cornerRadius = Size.Common.cornerRadius16
        b.clipsToBounds = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let uploadPlusIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: Images.Generation.plusImage)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let uploadedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let gradientSpinner: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Settings
    
    private let formatRow = VideoSettingRow(title: "Format", value: "16:9")
    private let qualityRow = VideoSettingRow(title: "Quality", value: "1080p")
    
    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Create Button
    
    private let createGradientView: GradientView = {
        let v = GradientView(
            colors: [.cmBlue, .cmPink],
            startPoint: CGPoint(x: 0, y: 0.5),
            endPoint: CGPoint(x: 1, y: 0.5)
        )
        v.layer.cornerRadius = Size.Common.cornerRadius20
        v.clipsToBounds = true
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let createButton: UIButton = {
        let b = UIButton()
        b.setTitle(Strings.Generation.createText, for: .normal)
        b.titleLabel?.font = Typography.b16.font
        b.layer.cornerRadius = Size.Common.cornerRadius20
        b.backgroundColor = .cmChocolate
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isEnabled = false
        return b
    }()
    
    private let removeImageButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Generation.removeImage), for: .normal)
        b.isHidden = true
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
        guard !didLayout, bounds.width > 0 else { return }
        didLayout = true
        setupUploadBorder()
        setupSpinner()
        updateCreateButton()
        carouselCollectionView.collectionViewLayout.invalidateLayout()
        carouselCollectionView.reloadData()
    }
    
    // MARK: - Public
    
    func configure(title: String, images: [UIImage]) {
        titleLabel.text = title
        templateImages = images
        carouselCollectionView.reloadData()
        
        guard images.count > 1 else { return }
        DispatchQueue.main.async {
            self.carouselCollectionView.scrollToItem(
                at: IndexPath(item: 1, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
    
    func showUploadLoading() {
        uploadPlusIcon.isHidden = true
        uploadedImageView.isHidden = true
        gradientSpinner.isHidden = false
        uploadButton.backgroundColor = .cmChocolate
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 0.8
        rotation.repeatCount = .infinity
        gradientSpinner.layer.add(rotation, forKey: "spin")
    }
    
    func showUploadedImage(_ image: UIImage) {
        uploadedImage = image
        gradientSpinner.isHidden = true
        gradientSpinner.layer.removeAnimation(forKey: "spin")
        uploadedImageView.image = image
        uploadedImageView.isHidden = false
        uploadPlusIcon.isHidden = true
        removeImageButton.isHidden = false
        uploadButton.layer.cornerRadius = Size.Common.cornerRadius16
        updateCreateButton()
    }
    
    func setFormat(_ format: String) { formatRow.setValue(format) }
    func setQuality(_ quality: String) { qualityRow.setValue(quality) }
}

// MARK: - Setup

private extension VideoGenerationView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        removeImageButton.addTarget(self, action: #selector(didTapRemoveImage), for: .touchUpInside)
        formatRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFormat)))
        qualityRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapQuality)))
    }
    
    @objc func didTapBack() { delegate?.didTapBack() }
    @objc func didTapUpload() { delegate?.didTapUploadImage() }
    @objc func didTapCreate() { delegate?.didTapCreate() }
    @objc func didTapFormat() { delegate?.didTapFormat() }
    @objc func didTapQuality() { delegate?.didTapQuality() }
    
    @objc func didTapRemoveImage() {
        uploadedImage = nil
        uploadedImageView.isHidden = true
        uploadedImageView.image = nil
        uploadPlusIcon.isHidden = false
        removeImageButton.isHidden = true
        uploadButton.backgroundColor = .clear
        updateCreateButton()
    }
    
    func setupViews() {
        backgroundColor = .black
    
        formatRow.translatesAutoresizingMaskIntoConstraints = false
        qualityRow.translatesAutoresizingMaskIntoConstraints = false
        
        uploadButton.addSubviews(uploadPlusIcon, uploadedImageView, gradientSpinner)
        topBar.addSubviews(backButton, titleLabel)
        
        addSubviews(
            carouselCollectionView,
            topBar,
            uploadButton,
            removeImageButton,
            formatRow,
            separator,
            qualityRow,
            createGradientView,
            createButton
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Constants.topBarHSize),
            
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: Insets.s56),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            backButton.widthAnchor.constraint(equalToConstant: Insets.s32),
            backButton.heightAnchor.constraint(equalToConstant: Insets.s32),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            carouselCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Insets.s16),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: Constants.carouselCollectionViewHSize),
            
            removeImageButton.topAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -Insets.s8),
            removeImageButton.trailingAnchor.constraint(equalTo: uploadButton.trailingAnchor, constant: Insets.s8),
            removeImageButton.widthAnchor.constraint(equalToConstant: Insets.s24),
            removeImageButton.heightAnchor.constraint(equalToConstant: Insets.s24),
            
            uploadedImageView.topAnchor.constraint(equalTo: uploadButton.topAnchor),
            uploadedImageView.leadingAnchor.constraint(equalTo: uploadButton.leadingAnchor),
            uploadedImageView.trailingAnchor.constraint(equalTo: uploadButton.trailingAnchor),
            uploadedImageView.bottomAnchor.constraint(equalTo: uploadButton.bottomAnchor),
            
            uploadButton.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: Insets.s24),
            uploadButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            uploadButton.widthAnchor.constraint(equalToConstant: Constants.uploadButtonSize),
            uploadButton.heightAnchor.constraint(equalToConstant: Constants.uploadButtonSize),
            
            uploadPlusIcon.centerXAnchor.constraint(equalTo: uploadButton.centerXAnchor),
            uploadPlusIcon.centerYAnchor.constraint(equalTo: uploadButton.centerYAnchor),
            uploadPlusIcon.widthAnchor.constraint(equalToConstant: Constants.uploadPlusIconSize),
            uploadPlusIcon.heightAnchor.constraint(equalToConstant: Constants.uploadPlusIconSize),
            
            gradientSpinner.centerXAnchor.constraint(equalTo: uploadButton.centerXAnchor),
            gradientSpinner.centerYAnchor.constraint(equalTo: uploadButton.centerYAnchor),
            gradientSpinner.widthAnchor.constraint(equalToConstant: Constants.gradientSpinnerSize),
            gradientSpinner.heightAnchor.constraint(equalToConstant: Constants.gradientSpinnerSize),
            
            formatRow.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: Insets.s24),
            formatRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            formatRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            formatRow.heightAnchor.constraint(equalToConstant: Constants.formatRowHSize),
            
            separator.topAnchor.constraint(equalTo: formatRow.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: Constants.separatorHSize),
            
            qualityRow.topAnchor.constraint(equalTo: separator.bottomAnchor),
            qualityRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            qualityRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            qualityRow.heightAnchor.constraint(equalToConstant: Constants.qualityRowHSize),
            
            createGradientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            createGradientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            createGradientView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Insets.s32),
            createGradientView.heightAnchor.constraint(equalToConstant: Constants.gradientViewHSize),
            
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s16),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s16),
            createButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Insets.s32),
            createButton.heightAnchor.constraint(equalToConstant: Constants.createButtonHSize)
        ])
    }
    
    func setupUploadBorder() {
        uploadBorderLayer.removeFromSuperlayer()
        let frame = uploadButton.frame
        guard frame.width > 0 else { return }
        
        uploadBorderLayer.colors = [UIColor.cmBlue.cgColor, UIColor.cmPink.cgColor]
        uploadBorderLayer.startPoint = CGPoint(x: 0, y: 0)
        uploadBorderLayer.endPoint = CGPoint(x: 1, y: 1)
        uploadBorderLayer.frame = CGRect(
            x: frame.minX - 2,
            y: frame.minY - 2,
            width: frame.width + 4,
            height: frame.height + 4
        )
        
        let mask = CAShapeLayer()
        let outer = UIBezierPath(
            roundedRect: uploadBorderLayer.bounds,
            cornerRadius: 18 // 16 + 2
        )
        let inner = UIBezierPath(
            roundedRect: CGRect(
                x: 2,
                y: 2,
                width: frame.width,
                height: frame.height
            ),
            cornerRadius: Size.Common.cornerRadius16
        )
        outer.append(inner)
        mask.path = outer.cgPath
        mask.fillRule = .evenOdd
        uploadBorderLayer.mask = mask
        layer.insertSublayer(uploadBorderLayer, below: uploadButton.layer)
    }
    
    func setupSpinner() {
        let size: CGFloat = 36
        let center = CGPoint(x: size / 2, y: size / 2)
        let radius = size / 2 - 3
        let lineWidth: CGFloat = 3
        
        spinnerMaskLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5 * 0.85,
            clockwise: true
        ).cgPath
        
        spinnerMaskLayer.lineWidth = lineWidth
        spinnerMaskLayer.fillColor = UIColor.clear.cgColor
        spinnerMaskLayer.strokeColor = UIColor.white.cgColor
        spinnerMaskLayer.lineCap = .round
        
        spinnerGradientLayer.colors = [UIColor.cmPink.cgColor, UIColor.cmBlue.cgColor]
        spinnerGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        spinnerGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        spinnerGradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        spinnerGradientLayer.mask = spinnerMaskLayer
        
        gradientSpinner.layer.addSublayer(spinnerGradientLayer)
    }
    
    func updateCreateButton() {
        let hasImage = uploadedImage != nil
        createButton.isEnabled = hasImage
        createGradientView.isHidden = !hasImage
        createButton.backgroundColor = hasImage ? .clear : .cmChocolate
        createButton.setTitleColor(
            hasImage ? .white : UIColor.white.withAlphaComponent(0.4),
            for: .normal
        )
    }
}

// MARK: - UICollectionViewDataSource

extension VideoGenerationView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        templateImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TemplatePreviewCell.reuseId,
            for: indexPath
        ) as? TemplatePreviewCell else { return UICollectionViewCell() }
        cell.configure(image: templateImages[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension VideoGenerationView: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let itemWidth: CGFloat = Constants.itemWidth // 331 + 12
        let offset = targetContentOffset.pointee.x + scrollView.contentInset.left
        let index = (offset / itemWidth).rounded()
        targetContentOffset.pointee = CGPoint(
            x: index * itemWidth - scrollView.contentInset.left,
            y: 0
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension VideoGenerationView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.sizeForItem
    }
}
