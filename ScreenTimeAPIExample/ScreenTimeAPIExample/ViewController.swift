//
//  ViewController.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let _blockYouTubeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("유튜브 차단하기", for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(_buttonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }
}

extension ViewController {
    private func _setup() {
        _setDelegates()
        _addSubviews()
        _setConstraints()
    }
    
    private func _setDelegates() {
        // TODO: Set delegates
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
    @objc private func _buttonPressed() {
        print("button pressed")
    }
}
