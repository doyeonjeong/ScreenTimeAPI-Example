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
    
    private let youTubeBlocker = YouTubeBlocker()
    private let center = AuthorizationCenter.shared
    private let _contentView = UIHostingController(rootView: SwiftUIView())
    
    private let _blockYouTubeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("유튜브 차단하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController {
    private func _setup() {
        _addSubviews()
        _setConstraints()
        _addTargets()
    }
    
    private func _addTargets() {
        _blockYouTubeButton.addTarget(self, action: #selector(_blockYouTubeButtonTapped), for: .touchUpInside)
    }
    
    private func _addSubviews() {
        view.addSubview(_blockYouTubeButton)
        addChild(_contentView)
        view.addSubview(_contentView.view)
    }
    
    private func _setConstraints() {
        
        _contentView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            _contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _contentView.view.bottomAnchor.constraint(equalTo: _blockYouTubeButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            _blockYouTubeButton.topAnchor.constraint(equalTo: _contentView.view.bottomAnchor),
            _blockYouTubeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _blockYouTubeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _blockYouTubeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
}

extension ViewController {
    @objc private func _blockYouTubeButtonTapped() {
        print("_blockYouTubeButtonTapped")
        youTubeBlocker.blockYouTube { result in
            switch result {
            case .success():
                print("유튜브 차단 성공")
            case .failure(let error):
                print("유튜브 차단 실패: \(error.localizedDescription)")
            }
        }
    }
}
