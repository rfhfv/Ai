//
//  OptionsBottomSheet.swift
//  Ai
//
//  Created by admin on 28.06.2026.
//

import UIKit

final class OptionsBottomSheet: UIViewController {

    private let options: [String]
    private var selectedOption: String
    private let onSelect: (String) -> Void
    
    private let dimView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let sheetView: UIView = {
        let v = UIView()
        v.backgroundColor = .cmNight
        v.layer.cornerRadius = Size.Common.cornerRadius20
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let handleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        v.layer.cornerRadius = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    private var sheetBottomConstraint = NSLayoutConstraint()
    
    // MARK: - Init
    
    init(options: [String], selected: String, onSelect: @escaping (String) -> Void) {
        self.options = options
        self.selectedOption = selected
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
}

// MARK: - Setup UI

private extension OptionsBottomSheet {
    
    func setupUI() {
        setupViews()
        setupConstraints()
        setupGestures()
        buildOptionRows()
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(dimView)
        view.addSubview(sheetView)
        sheetView.addSubview(handleView)
        sheetView.addSubview(stackView)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDim))
        dimView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        sheetView.addGestureRecognizer(pan)
    }
    
    func setupConstraints() {
        sheetBottomConstraint = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetBottomConstraint,
            
            handleView.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: Insets.s8),
            handleView.centerXAnchor.constraint(equalTo: sheetView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 36),
            handleView.heightAnchor.constraint(equalToConstant: 4),
            
            stackView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: Insets.s8),
            stackView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func buildOptionRows() {
        options.enumerated().forEach { index, option in
            let row = makeRow(title: option, isSelected: option == selectedOption)
            stackView.addArrangedSubview(row)
            
            if index < options.count - 1 {
                let sep = makeSeparator()
                stackView.addArrangedSubview(sep)
            }
        }
    }
    
    func makeRow(title: String, isSelected: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        let label = UILabel()
        label.text = title
        label.font = Typography.r20.font
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if isSelected {
            label.setGradientText(
                fullText: title,
                gradientPart: title,
                font: Typography.r20.font,
                gradientColors: [.cmPink, .cmBlue]
            )
        } else {
            label.textColor = .white
        }
        
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Insets.s16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRow(_:)))
        container.addGestureRecognizer(tap)
        container.accessibilityLabel = title
        
        return container
    }
    
    func makeSeparator() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return v
    }
}

// MARK: - Actions

private extension OptionsBottomSheet {
    
    @objc func didTapDim() { animateOut() }
    
    @objc func didTapRow(_ gesture: UITapGestureRecognizer) {
        guard let title = gesture.view?.accessibilityLabel else { return }
        onSelect(title)
        animateOut()
    }
    
    @objc func didPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                sheetBottomConstraint.constant = translation.y
            }
        case .ended:
            let velocity = gesture.velocity(in: view)
            if translation.y > 100 || velocity.y > 500 {
                animateOut()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sheetBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}

// MARK: - Animation

private extension OptionsBottomSheet {
    
    func animateIn() {
        sheetBottomConstraint.constant = sheetView.bounds.height
        view.layoutIfNeeded()
        
        sheetBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dimView.alpha = 0.5
            self.view.layoutIfNeeded()
        }
    }
    
    func animateOut() {
        sheetBottomConstraint.constant = sheetView.bounds.height
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.dimView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}
