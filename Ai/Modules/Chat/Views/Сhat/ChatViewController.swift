//
//  ChatViewController.swift
//  Ai
//
//  Created by admin on 22.06.2026.
//

import UIKit

final class ChatViewController: UIViewController {

    private let chatView = ChatView()
    private let presenter: ChatPresenterProtocol
    private var customKeyboard: CustomKeyboardView?
    private var messages: [ChatMessage] = []

    // MARK: - Init

    init(presenter: ChatPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupDelegates()
        setupCustomKeyboard()
        setupGestures()
        presenter.viewDidLoad()
    }
}

private extension ChatViewController {
    
    func setupDelegates() {
        chatView.delegate = self
        chatView.textField.delegate = self
        chatView.tableView.dataSource = self
    }

    func setupCustomKeyboard() {
        let keyboard = CustomKeyboardView()
        keyboard.delegate = self
        keyboard.textInput = chatView.textField
        keyboard.parentView = view
        customKeyboard = keyboard

        chatView.textField.inputView = keyboard
        chatView.textField.inputAssistantItem.leadingBarButtonGroups = []
        chatView.textField.inputAssistantItem.trailingBarButtonGroups = []
    }

    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func send(_ text: String) {
        guard !text.isEmpty else { return }
        chatView.textField.text = ""
        customKeyboard?.clearText()
        view.endEditing(true)
        presenter.sendMessage(text: text)
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {

    func appendMessage(_ message: ChatMessage) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        chatView.tableView.insertRows(at: [indexPath], with: .fade)
        scrollToBottom()
    }

    func replaceLastMessage(with message: ChatMessage) {
        guard !messages.isEmpty else { return }
        let lastIndex = messages.count - 1
        messages[lastIndex] = message
        let indexPath = IndexPath(row: lastIndex, section: 0)
        chatView.tableView.reloadRows(at: [indexPath], with: .fade)
        scrollToBottom()
    }

    func showError(_ text: String) {
        print("Chat error: \(text)")
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        switch message.role {
        case .user:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserMessageCell.reuseId, for: indexPath) as?  UserMessageCell else { return UITableViewCell() }
            cell.configure(with: message.text)
            return cell

        case .assistant:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssistantMessageCell.reuseId, for: indexPath) as? AssistantMessageCell else { return UITableViewCell() }
            cell.configure(with: message.text)
            return cell

        case .loading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseId, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            cell.startAnimating()
            return cell
        }
    }
}

// MARK: - ChatviewDelegate

extension ChatViewController: ChatviewDelegate {
    func didTapBack() {
        presenter.didTapBack()
    }

    func didTapSendMessage(_ text: String) {
        send(text)
    }
    
    func didTapHistory() {
        presenter.didTapHistory()
    }
}

// MARK: - CustomKeyboardDelegate

extension ChatViewController: CustomKeyboardDelegate {
    func keyPressed(_ key: String) {}
    func backspacePressed() {}
    func returnPressed() {}
    func switchToNumbers() {}

    func didTapMicrophone() {}
    
    func keyboardDidSend(_ text: String) {
        send(text)
    }
}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send(textField.text ?? "")
        return true
    }
}
