//
//  Error.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import UIKit

final class ErrorView: UIView {
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.text = "Error! Check your internet connection or restart the app!"
        return label
    }()

    var text: String? {
        didSet {
            errorLabel.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .red
        isUserInteractionEnabled = true
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
    }
}
