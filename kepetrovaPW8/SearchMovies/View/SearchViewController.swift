import UIKit
protocol SearchModuleViewInput: AnyObject {
    func update(state: MoviePresenterState)
    func openNew(next: UIViewController)
}

protocol SearchModuleViewOutput: AnyObject {
    func getCount() -> Int
    func getDataMovie(indexPath: Int) -> Movie
    func MovieTapped(indexPath: Int)
    func search(index: Int, _ name: String)
    func getPages() -> Int
}

final class SearchViewController: UIViewController {
    var moviesViewModel: SearchModuleViewOutput
    private lazy var loadingView = SquareLoadingView()
    private var searchDebouncerTimer: Timer?
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
        searchBar.placeholder = "Enter a movie..."
        searchBar.showsCancelButton = false
        return searchBar
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray3
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(output: SearchModuleViewOutput) {
        moviesViewModel = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupErrorViewConstraints()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(tableView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: errorView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 50),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.topAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)

        ])
    }

    private var tag = 1
    private func setnum() {
        let allViews = stackView.arrangedSubviews
        for item in allViews {
            stackView.removeArrangedSubview(item)
        }

        for i in 1 ... moviesViewModel.getPages() {
            let viewc = UIButton()
            viewc.backgroundColor = .systemGray3
            viewc.setTitle(String(i), for: .normal)

            viewc.setTitleColor(.white, for: .normal)
            viewc.tag = i
            viewc.addTarget(self, action: #selector(loadMore(sender:)), for: .touchUpInside)

            if tag == viewc.tag {
                viewc.backgroundColor = .systemMint
            }

            stackView.addArrangedSubview(viewc)
        }
        print(tag)
        for view in stackView.arrangedSubviews {
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 40),
                view.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

    @objc
    private func loadMore(sender: UIButton) {
        tag = sender.tag
        print(tag)
        moviesViewModel.search(index: sender.tag, searchBar.text ?? "")
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
                       options: [.curveEaseInOut])
        {
            self.errorConstraint?.constant = 35
            self.errorView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func hideError() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseOut])
        {
            self.errorConstraint?.constant = 0
            self.errorView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc func handleTap(_: UITapGestureRecognizer) {
        hideError()
    }
}

extension SearchViewController: SearchModuleViewInput {
    func update(state: MoviePresenterState) {
        switch state {
        case .loading:
            setupLoading()
            tableView.isHidden = true
            scrollView.isHidden = true
            loadingView.startAnimation()
        case .error:
            tableView.isHidden = true
            scrollView.isHidden = true
            loadingView.stopAnimation()
            DispatchQueue.main.async {
                self.showError()
            }
        case .success:
            loadingView.stopAnimation()
            setnum()
            tableView.reloadData()
            scrollView.reloadInputViews()
            tableView.isHidden = false
            scrollView.isHidden = false
        case .none:
            tableView.isHidden = true
            scrollView.isHidden = true
        }
    }

    func openNew(next: UIViewController) {
        present(next, animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.getCount()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = moviesViewModel.getDataMovie(indexPath: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.indentifier, for: indexPath) as! MovieCell
        cell.configure(data: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesViewModel.MovieTapped(indexPath: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDebouncerTimer?.invalidate()

        let timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: false
        ) { [weak self] _ in
            self?.fireTimer()
        }

        searchDebouncerTimer = timer
    }

    private func fireTimer() {
        if !(searchBar.text?.isEmpty ?? true) {
            moviesViewModel.search(index: 1, searchBar.text ?? "")
        }
    }
}
