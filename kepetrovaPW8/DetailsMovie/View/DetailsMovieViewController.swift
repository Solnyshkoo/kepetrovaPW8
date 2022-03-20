//
//  DetailsMovieViewController.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

import Foundation
import UIKit
protocol DetailsModuleViewInput: AnyObject {
    func update(state: DetailMoviePresenterState)
}

protocol DetailsModuleViewOutput: AnyObject {
    func loadData()
    func getDataMovie() -> DetailsPresenter
}

final class DetailsMovieViewController: UIViewController {
    var moviesViewModel: DetailsModuleViewOutput
    private lazy var loadingView = SquareLoadingView()
    private var errorConstraint: NSLayoutConstraint?
    
//    private lazy var errorView: ErrorView = {
//        let view = ErrorView()
//        view.alpha = 0
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isUserInteractionEnabled = true
//
//        let tapActionHideError = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        view.addGestureRecognizer(tapActionHideError)
//        return view
//    }()

    
    init(output: DetailsModuleViewOutput) {
        moviesViewModel = output
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       // setupErrorViewConstraints()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(stackView)
        //scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)

        ])
    }
    private func setStackView() {
        let newView = DetailsMoviewView()
        newView.configure(data: moviesViewModel.getDataMovie())
        stackView.addArrangedSubview(newView)
        for view in stackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                view.topAnchor.constraint(equalTo: stackView.topAnchor),
                view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            ])
        }
    }
    
    private func setupLoading() {
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
//    private func setupErrorViewConstraints() {
//        view.addSubview(errorView)
//        view.addSubview(searchBar)
//        let errorConstraint = errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//        NSLayoutConstraint.activate([
//            errorView.topAnchor.constraint(equalTo: view.topAnchor),
//            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            errorConstraint,
//            errorView.heightAnchor.constraint(equalToConstant: 90)
//
//        ])
//
//        self.errorConstraint = errorConstraint
//    }

    // MARK: Show/hide errors function

//    func showError() {
//        UIView.animate(withDuration: 0.5,
//                       delay: 0.0,
//                       options: [.curveEaseInOut])
//        {
//            self.errorConstraint?.constant = 35
//            self.errorView.alpha = 1
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func hideError() {
//        UIView.animate(withDuration: 0.5,
//                       delay: 0.0,
//                       options: [.curveEaseOut])
//        {
//            self.errorConstraint?.constant = 0
//            self.errorView.alpha = 0
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    @objc func handleTap(_: UITapGestureRecognizer) {
//        hideError()
//    }
   
}

extension DetailsMovieViewController: DetailsModuleViewInput {
    func update(state: DetailMoviePresenterState) {
        switch state {
        case .loading:
            setupLoading()
//            tableView.isHidden = true
            scrollView.isHidden = true
           loadingView.startAnimation()
        case .error:
//            tableView.isHidden = true
           scrollView.isHidden = true
           loadingView.stopAnimation()
//          DispatchQueue.main.async {
//                self.showError()
//            }
        case .success:
             loadingView.stopAnimation()
//            setnum()
//            tableView.reloadData()
            setStackView()
            stackView.reloadInputViews()
          // scrollView.reloadInputViews()
            //tableView.isHidden = false
            scrollView.isHidden = false
        case .none: break
//            tableView.isHidden = true
//            scrollView.isHidden = true
        }
    }
}
