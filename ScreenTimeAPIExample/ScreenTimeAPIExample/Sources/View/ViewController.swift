//
//  ViewController.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let youTubeBlocker = YouTubeBlocker()
    
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
    }
    
    private func _setConstraints() {
        NSLayoutConstraint.activate([
            _blockYouTubeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _blockYouTubeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ViewController {
    @objc private func _blockYouTubeButtonTapped() {
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
