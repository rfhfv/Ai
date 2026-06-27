//
//  ChatHistoryView.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

protocol ChatHistoryViewDelegate: AnyObject {
    func didTapBack()
}

final class ChatHistoryView: UIView {
    
    private enum Constants {
        static let topBarHSize: CGFloat = 129
        static let backButtonSize: CGFloat = 24
        static let emptyIconViewSize: CGFloat = 60
        static let emptyContainerHSize: CGFloat = 156
        static let emptyContainerTopInset: CGFloat = 300
    }
    
    weak var delegate: ChatHistoryViewDelegate?
    private(set) var sections: [ChatHistorySection] = []
    
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 72
        tv.sectionHeaderTopPadding = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ChatHistoryCell.self, forCellReuseIdentifier: ChatHistoryCell.reuseId)
        tv.register(ChatHistorySectionHeader.self, forHeaderFooterViewReuseIdentifier: ChatHistorySectionHeader.reuseId)
        return tv
    }()
    
    // MARK: - UI Elements
    
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
        l.configureLabel(text: Strings.ChatHistory.title, font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // Empty state
    
    private let emptyContainer: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let emptyIconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.ChatHistory.magicPencil)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emptyTitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.ChatHistory.emptyTitle, font: Typography.b28.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let emptySubtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.ChatHistory.emptySubtitle, font: Typography.r16.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func bind(sections: [ChatHistorySection]) {
        self.sections = sections
        tableView.isHidden = false
        emptyContainer.isHidden = true
        tableView.reloadData()
    }
    
    func showEmptyState() {
        tableView.isHidden = true
        emptyContainer.isHidden = false
    }
}

// MARK: - Private

private extension ChatHistoryView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .black
        
        emptyContainer.addSubviews(emptyIconView, emptyTitleLabel, emptySubtitleLabel)
        topBar.addSubviews(backButton, titleLabel)
        addSubviews(topBar, tableView, emptyContainer)
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBack()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Constants.topBarHSize),
            
            backButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: Insets.s80),
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: Insets.s16),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonSize),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.emptyContainerTopInset),
            emptyContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Insets.s24),
            emptyContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s24),
            emptyContainer.heightAnchor.constraint(equalToConstant: Constants.emptyContainerHSize),
            
            emptyIconView.topAnchor.constraint(equalTo: emptyContainer.topAnchor),
            emptyIconView.centerXAnchor.constraint(equalTo: emptyContainer.centerXAnchor),
            emptyIconView.widthAnchor.constraint(equalToConstant: Constants.emptyIconViewSize),
            emptyIconView.heightAnchor.constraint(equalToConstant: Constants.emptyIconViewSize),
            
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyIconView.bottomAnchor, constant: Insets.s16),
            emptyTitleLabel.centerXAnchor.constraint(equalTo: emptyContainer.centerXAnchor),
            
            emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: Insets.s8),
            emptySubtitleLabel.leadingAnchor.constraint(equalTo: emptyContainer.leadingAnchor),
            emptySubtitleLabel.trailingAnchor.constraint(equalTo: emptyContainer.trailingAnchor),
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyContainer.bottomAnchor)
        ])
    }
}
