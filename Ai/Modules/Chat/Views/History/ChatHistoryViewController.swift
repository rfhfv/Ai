//
//  ChatHistoryViewController.swift
//  Ai
//
//  Created by admin on 26.06.2026.
//

import UIKit

final class ChatHistoryViewController: UIViewController {
    
    private enum Constants {
        static let tableViewHSize: CGFloat = 40
    }
    
    private let historyView = ChatHistoryView()
    private let presenter: ChatHistoryPresenterProtocol
    
    // MARK: - Init
    
    init(presenter: ChatHistoryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupDelegates()
        presenter.viewDidLoad()
    }
    
    private func setupDelegates() {
        historyView.delegate = self
        historyView.tableView.dataSource = self
        historyView.tableView.delegate = self
    }
}

// MARK: - ChatHistoryViewProtocol

extension ChatHistoryViewController: ChatHistoryViewProtocol {
    
    func showChats(_ sections: [ChatHistorySection]) {
        historyView.bind(sections: sections)
    }
    
    func showEmpty() {
        historyView.showEmptyState()
    }
}

// MARK: - UITableViewDataSource

extension ChatHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        historyView.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyView.sections[section].chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatHistoryCell.reuseId, for: indexPath) as! ChatHistoryCell
        let chat = historyView.sections[indexPath.section].chats[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatHistorySectionHeader.reuseId) as! ChatHistorySectionHeader
        header.configure(title: historyView.sections[section].title)
        return header
    }
}

// MARK: - UITableViewDelegate

extension ChatHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = historyView.sections[indexPath.section].chats[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.tableViewHSize
    }
}

// MARK: - ChatHistoryViewDelegate

extension ChatHistoryViewController: ChatHistoryViewDelegate {
    func didTapBack() {
        presenter.didTapBack()
    }
}
