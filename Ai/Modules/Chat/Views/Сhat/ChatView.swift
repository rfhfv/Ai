//
//  ChatView.swift
//  Ai
//
//  Created by admin on 24.06.2026.
//

import UIKit

protocol ChatviewDelegate: AnyObject {
    func didTapBack()
    func didTapSendMessage(_ text: String)
    func didTapHistory()
}

final class ChatView: UIView {
    
    private enum Constants {
        static let topBarSize: CGFloat = 129
        static let avatarIconViewSize: CGFloat = 32
        static let inputContainerSize: CGFloat = 122
        static let importButtonSize: CGFloat = 40
        static let microButtonSize: CGFloat = 40
    }
    
    weak var delegate: ChatviewDelegate?
    var textField: UITextField { inputTextField }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 200
        tv.keyboardDismissMode = .interactive
        tv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserMessageCell.self, forCellReuseIdentifier: UserMessageCell.reuseId)
        tv.register(AssistantMessageCell.self, forCellReuseIdentifier: AssistantMessageCell.reuseId)
        tv.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseId)
        return tv
    }()
    
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
        iv.image = UIImage(named: Images.Chat.aIChatSparksImage)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Chat.aiChatTitle, font: Typography.b20.font)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.configureLabel(text: Strings.Chat.dateTitle, font: Typography.r14.font, color: .cmGray)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let titleStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 2
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private let historyButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: Images.Chat.historyImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let inputContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .cmChocolate
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.clipsToBounds = true
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let inputTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: Strings.Chat.placeholder,
            attributes: [.foregroundColor: UIColor.gray]
        )
        tf.textColor = .white
        tf.font = Typography.r16.font
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let importButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: Images.Chat.importImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let microButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: Images.Chat.microImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
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
}

private extension ChatView {
    
    func setupUI() {
        backgroundColor = .black
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    func setupViews() {
        titleStack.addArrangedSubviews(titleLabel, subtitleLabel)
        topBar.addSubviews(backButton, avatarIconView, titleStack, historyButton)
        inputContainer.addSubviews(inputTextField, importButton, microButton)
        addSubviews(topBar, tableView, inputContainer)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        importButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(didTapHistoryButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBack()
    }
    
    @objc func didTapSend() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        delegate?.didTapSendMessage(text)
        inputTextField.text = ""
    }
    
    @objc func didTapHistoryButton() {
        delegate?.didTapHistory()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Constants.topBarSize),
            
            backButton.topAnchor.constraint(equalTo: topBar.topAnchor, constant: Insets.s80),
            backButton.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: Insets.s16),
            backButton.widthAnchor.constraint(equalToConstant: Insets.s24),
            
            avatarIconView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: Insets.s32),
            avatarIconView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            avatarIconView.heightAnchor.constraint(equalToConstant: Constants.avatarIconViewSize),
            avatarIconView.widthAnchor.constraint(equalToConstant: Constants.avatarIconViewSize),
            
            titleStack.leadingAnchor.constraint(equalTo: avatarIconView.trailingAnchor, constant: Insets.s12),
            titleStack.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            historyButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -Insets.s16),
            historyButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            historyButton.widthAnchor.constraint(equalToConstant: Insets.s24),
            
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),
            
            inputContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: Constants.inputContainerSize),
            
            importButton.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: Insets.s24),
            importButton.trailingAnchor.constraint(equalTo: microButton.leadingAnchor, constant: -Insets.s16),
            importButton.widthAnchor.constraint(equalToConstant: Constants.importButtonSize),
            importButton.heightAnchor.constraint(equalToConstant: Constants.importButtonSize),
            
            microButton.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: Insets.s24),
            microButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -Insets.s16),
            microButton.widthAnchor.constraint(equalToConstant: Constants.microButtonSize),
            microButton.heightAnchor.constraint(equalToConstant: Constants.microButtonSize),
            
            inputTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: Insets.s20),
            inputTextField.trailingAnchor.constraint(equalTo: importButton.leadingAnchor, constant: -Insets.s12),
            inputTextField.centerYAnchor.constraint(equalTo: microButton.centerYAnchor)
        ])
    }
}
