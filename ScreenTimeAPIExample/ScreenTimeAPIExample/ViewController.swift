//
//  ViewController.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private let _helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.addSubview(_helloWorldLabel)
    }
    
    private func _setConstraints() {
        NSLayoutConstraint.activate([
            _helloWorldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _helloWorldLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
