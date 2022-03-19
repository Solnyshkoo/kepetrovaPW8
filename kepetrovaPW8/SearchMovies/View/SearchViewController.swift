//
//  ViewController.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import UIKit



final class SearchViewController: UIViewController {
    private lazy var loadingView = SquareLoadingView()
    private var errorConstraint: NSLayoutConstraint?
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.indentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.sectionHeaderTopPadding = .zero
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
     
        let tapActionHideError = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapActionHideError)
        return view
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.white
        searchBar.searchTextField.textColor = UIColor.black
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.searchBarStyle = .minimal
        searchBar.layer.cornerRadius = 15

       // searchBar.tintColor = ColorPalette.mainText
       // searchBar.searchTextField.leftView?.tintColor = ColorPalette.mainText
        searchBar.placeholder = "Enter a movie..."
        searchBar.showsCancelButton = false
        return searchBar
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .white
      
        setupErrorViewConstraints()
        configureUI()
    }

    
    private func configureUI() {
       
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: errorView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupLoading() {
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    // MARK: ErrorView Constraints

    private func setupErrorViewConstraints() {
        view.addSubview(errorView)
        view.addSubview(searchBar)
        let errorConstraint = errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorConstraint,
            errorView.heightAnchor.constraint(equalToConstant: 90)
              
        ])
           
        self.errorConstraint = errorConstraint
    }

    // MARK: Show/hide errors function

    func showError() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseInOut]) {
            self.errorConstraint?.constant = 35
            self.errorView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func hideError() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseOut]) {
            self.errorConstraint?.constant = 0
            self.errorView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc func handleTap(_: UITapGestureRecognizer) {
        hideError()
    }
}

extension SearchViewController: MoviesModuleViewInput {
    func update(state: MoviePresenterState) {
        switch state {
        case .loading:
            setupLoading()
            loadingView.startAnimation()
        case .error:
            loadingView.stopAnimation()
            DispatchQueue.main.async {
                self.showError()
            }
        case .success:
            loadingView.stopAnimation()
            configureUI()
        case .none:
            break
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
       // return moviesViewModel.getCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = moviesViewModel.getDataMovie(indexPath: indexPath.row)
//        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.indentifier, for: indexPath) as! MovieCell
//        cell.configure(data: data)
//        return cell
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchDebouncerTimer?.invalidate()
//
//        let timer = Timer.scheduledTimer(
//            withTimeInterval: 1.0,
//            repeats: false
//        ) { [weak self] _ in
//            self?.fireTimer()
//        }
//
//        searchDebouncerTimer = timer
//    }
//
//    private func fireTimer() {
//        if searchBar.text?.isEmpty ?? true {
//            updateState(.startScreen)
//        } else {
//            output?.search(searchBar.text ?? "")
//        }
//    }
}



