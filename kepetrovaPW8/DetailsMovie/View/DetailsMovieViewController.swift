//
//  DetailsMovieViewController.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

import Foundation
import UIKit
protocol DetailsModuleViewInput: AnyObject {
    func update(state: MoviePresenterState)
}

protocol DetailsModuleViewOutput: AnyObject {
}

final class DetailsMovieViewController: UIViewController {
    var moviesViewModel: DetailsModuleViewOutput
    
    
    init(output: DetailsModuleViewOutput) {
        moviesViewModel = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        setupErrorViewConstraints()
//        configureUI()
    }
}

extension DetailsMovieViewController: DetailsModuleViewInput {
    func update(state: MoviePresenterState) {
        switch state {
        case .loading: break
//            setupLoading()
//            tableView.isHidden = true
//            scrollView.isHidden = true
//            loadingView.startAnimation()
        case .error: break
//            tableView.isHidden = true
//            scrollView.isHidden = true
//            loadingView.stopAnimation()
//            DispatchQueue.main.async {
//                self.showError()
//            }
        case .success: break
//            loadingView.stopAnimation()
//            setnum()
//            tableView.reloadData()
//            scrollView.reloadInputViews()
//            tableView.isHidden = false
//            scrollView.isHidden = false
        case .none: break
//            tableView.isHidden = true
//            scrollView.isHidden = true
        }
    }
}
