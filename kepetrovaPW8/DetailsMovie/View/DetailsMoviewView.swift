//
//  DetailsMoviewView.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

import Foundation
import UIKit
final class DetailsMoviewView: UIView {
    private lazy var overview: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var adult: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DetailsPresenter) {
        overview.text = data.overview
        print(data.overview)
        title.text = data.originalTitle
        adult.text = data.adult ?? false ? "+18" : ""
    }

    private func configureUI() {
        addSubview(overview)
        addSubview(title)
        addSubview(adult)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: adult.leadingAnchor, constant: -5),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.heightAnchor.constraint(equalToConstant: 50),
            
            adult.topAnchor.constraint(equalTo: topAnchor),
            adult.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            adult.heightAnchor.constraint(equalToConstant: 40),
            adult.widthAnchor.constraint(equalToConstant: 40),
            
            overview.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            overview.leadingAnchor.constraint(equalTo: leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: trailingAnchor),
            overview.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
//    private lazy var title: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    private lazy var title: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
}
