//
//  CustomKeyboardView.swift
//  Ai
//
//  Created by admin on 24.06.2026.
//

import UIKit

protocol CustomKeyboardDelegate: AnyObject {
    func keyPressed(_ key: String)
    func backspacePressed()
    func returnPressed()
    func switchToNumbers()
    func didTapMicrophone()
    func keyboardDidSend(_ text: String)
}

final class CustomKeyboardView: UIView {
    
    private enum Constants {
        static let topBarViewSize: CGFloat = 88
        static let buttonWSize: CGFloat = 80
        static let displayTextFieldSize: CGFloat = 40
        static let actionButtonSize: CGFloat = 40
        
        static let microphoneButtonHSize: CGFloat = 32
        static let microphoneButtonWSize: CGFloat = 27
        
        static let viewFrameHSize: CGFloat = 396
    }
    
    private enum KeyboardKey {
        static let rows: [[String]] = [
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"]
        ]
        static let numbers = "123"
        static let space = "space"
        static let `return` = "return"
        static let backspace = "⌫"
    }
    
    weak var delegate: CustomKeyboardDelegate?
    weak var textInput: UITextField?
    weak var parentView: UIView?
    
    private var isTextEmpty: Bool {
        textInput?.text?.isEmpty ?? true
    }
    
    private let topBarView: UIView = {
        let v = UIView()
        v.backgroundColor = .cmChocolate
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let displayTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: Strings.Chat.askPlaceholder,
            attributes: [.foregroundColor: UIColor.gray]
        )
        tf.textColor = .white
        tf.font = Typography.r16.font
        tf.backgroundColor = .cmChocolate
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    private let actionButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Chat.importImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let microphoneButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: Images.Chat.microFillImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        let width = UIScreen.main.bounds.width
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: Constants.viewFrameHSize))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }
    
    func clearText() {
        textInput?.text = ""
        syncState()
    }
}

private extension CustomKeyboardView {
    
    func setupUI() {
        backgroundColor = .cmChocolate
        clipsToBounds = false
        
        addSubviews(topBarView, microphoneButton)
        topBarView.addSubviews(displayTextField, actionButton)
        setupConstraints()
        setupKeyboardButtons()
        setupActions()
        applyCornerRadius()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: Constants.topBarViewSize),
            
            displayTextField.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: Insets.s32),
            displayTextField.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
            displayTextField.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -Insets.s32),
            displayTextField.heightAnchor.constraint(equalToConstant: Constants.displayTextFieldSize),
            
            actionButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -Insets.s16),
            actionButton.centerYAnchor.constraint(equalTo: displayTextField.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: Constants.actionButtonSize),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonSize),
            
            microphoneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Insets.s28),
            microphoneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Insets.s28),
            microphoneButton.heightAnchor.constraint(equalToConstant: Constants.microphoneButtonHSize),
            microphoneButton.widthAnchor.constraint(equalToConstant: Constants.microphoneButtonWSize)
        ])
    }
    
    func setupActions() {
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        microphoneButton.addTarget(self, action: #selector(didTapMicrophoneButton), for: .touchUpInside)
        textInput?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func applyCornerRadius() {
        layer.cornerRadius = Size.Common.cornerRadius16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - Keyboard Layout

private extension CustomKeyboardView {
    
    func setupKeyboardButtons() {
        let container = makeKeyboardContainer()
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: microphoneButton.topAnchor, constant: -Insets.s10)
        ])
        
        let stack = makeKeyboardStack()
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Insets.s8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Insets.s8),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: Insets.s10),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Insets.s10)
        ])
    }
    
    func makeKeyboardContainer() -> UIView {
        let v = UIView()
        v.backgroundColor = .cmChocolate
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = Size.Common.cornerRadius16
        v.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        v.clipsToBounds = true
        return v
    }
    
    func makeKeyboardStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Insets.s8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        KeyboardKey.rows.forEach { stack.addArrangedSubview(makeRowStack(keys: $0)) }
        stack.addArrangedSubview(makeBottomRow())
        return stack
    }
    
    func makeRowStack(keys: [String]) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = Insets.s6
        row.distribution = .fillEqually
        keys.forEach { row.addArrangedSubview(makeKeyButton(title: $0)) }
        return row
    }
    
    func makeBottomRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = Insets.s6
        row.distribution = .fill
        
        let numbers = makeKeyButton(title: KeyboardKey.numbers)
        numbers.widthAnchor.constraint(equalToConstant: Constants.buttonWSize).isActive = true
        
        let space = makeKeyButton(title: KeyboardKey.space)
        space.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let ret = makeKeyButton(title: KeyboardKey.return)
        ret.widthAnchor.constraint(equalToConstant: Constants.buttonWSize).isActive = true
        ret.backgroundColor = .cmGray
        
        [numbers, space, ret].forEach { row.addArrangedSubview($0) }
        return row
    }
    
    func makeKeyButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(
            ofSize: title.count > 3 ? 14 : 20,
            weight: .regular
        )
        b.backgroundColor = .cmDarkGray
        b.layer.cornerRadius = Size.Common.cornerRadius8
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(keyButtonTapped(_:)), for: .touchUpInside)
        return b
    }
}

// MARK: - Actions

private extension CustomKeyboardView {
    
    @objc func keyButtonTapped(_ sender: UIButton) {
        guard let key = sender.title(for: .normal), !key.isEmpty else { return }
        defer { syncState() }
        
        switch key {
        case KeyboardKey.backspace:
            textInput?.deleteBackward()
        case KeyboardKey.return:
            sendCurrentText()
        case KeyboardKey.numbers:
            delegate?.switchToNumbers()
        case KeyboardKey.space:
            textInput?.insertText(" ")
        default:
            textInput?.insertText(key.lowercased())
        }
    }
    
    @objc func didTapActionButton() {
        if isTextEmpty {
            delegate?.didTapMicrophone()
        } else {
            sendCurrentText()
        }
    }
    
    @objc func didTapMicrophoneButton() {
        delegate?.didTapMicrophone()
    }
    
    @objc func textFieldDidChange() {
        syncState()
    }
    
    func sendCurrentText() {
        guard let text = textInput?.text, !text.isEmpty else { return }
        delegate?.keyboardDidSend(text)
        textInput?.text = ""
        syncState()
        parentView?.endEditing(true)
    }
    
    func syncState() {
        displayTextField.text = textInput?.text
        
        if isTextEmpty {
            actionButton.setImage(UIImage(named: Images.Chat.importImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            actionButton.setImage(UIImage(named: Images.Chat.sendImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
            animateSendButton()
        }
    }
    
    func animateSendButton() {
        UIView.animate(withDuration: 0.1) {
            self.actionButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.actionButton.transform = .identity
            }
        }
    }
}
