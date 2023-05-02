//
//  ViewController.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/24.
//

import UIKit
import FamilyControls
import SwiftUI

final class ViewController: UIViewController {

    // MARK: - Properties
    var hostingController: UIHostingController<SwiftUIView>?
    
    private let _center = AuthorizationCenter.shared
    private let _youTubeBlocker = YouTubeBlocker()

    private lazy var _contentView: UIHostingController<some View> = {
        let model = BlockingApplicationModel.shared
        let hostingController = UIHostingController(
            rootView: SwiftUIView()
                .environmentObject(model)
        )
        return hostingController
    }()

    private let _blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let _releaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("해제하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let _buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _requestAuthorization()
    }
}

// MARK: - Setup
extension ViewController {
    private func _setup() {
        _addSubviews()
        _setConstraints()
        _addTargets()
    }

    private func _addTargets() {
        _blockButton.addTarget(self, action: #selector(_tappedBlockButton), for: .touchUpInside)
        _releaseButton.addTarget(self, action: #selector(_tappedReleaseButton), for: .touchUpInside)
    }

    private func _addSubviews() {
        _buttonStackView.addArrangedSubview(_blockButton)
        _buttonStackView.addArrangedSubview(_releaseButton)
        view.addSubview(_buttonStackView)
        addChild(_contentView)
        view.addSubview(_contentView.view)
    }

    private func _setConstraints() {

        _contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            _contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _contentView.view.bottomAnchor.constraint(equalTo: _blockButton.topAnchor)
        ])

        NSLayoutConstraint.activate([
            _buttonStackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            _buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            _buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            _buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
}

// MARK: - Actions
extension ViewController {
    @objc private func _tappedBlockButton() {
        _youTubeBlocker.block { result in
            switch result {
            case .success():
                print("차단 성공")
            case .failure(let error):
                print("차단 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func _tappedReleaseButton() {
        print("차단 해제")
        _youTubeBlocker.unblockAllApps()
    }
    
    private func _requestAuthorization() {
        Task {
            do {
                try await _center.requestAuthorization(for: .individual)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
