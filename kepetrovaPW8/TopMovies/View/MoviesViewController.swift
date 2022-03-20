import UIKit
// MARK: Protocols
protocol MoviesModuleViewInput: AnyObject {
    func update(state: MoviePresenterState)
    func openNew(next: UIViewController)
}

protocol MoviesModuleViewOutput: AnyObject {
    func getCount() -> Int
    func getDataMovie(indexPath: Int) -> Movie
    func MovieTapped(indexPath: Int)
    func updateView()
    func isLoadingCell(for indexPath: IndexPath) -> Bool
}

final class MoviesViewController: UIViewController {
    // MARK: Properties
    var moviesViewModel: MoviesModuleViewOutput
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupErrorViewConstraints()
        configureUI()
        tableView.isHidden = false
    }

    // MARK: init
    init(output: MoviesModuleViewOutput) {
        moviesViewModel = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI Configure
    private func configureUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: errorView.bottomAnchor),
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

// MARK: MoviesModuleViewInput
extension MoviesViewController: MoviesModuleViewInput {
    func update(state: MoviePresenterState) {
        switch state {
        case .loading:
            setupLoading()
            loadingView.startAnimation()
        case .error:
            tableView.isHidden = true
            loadingView.stopAnimation()
            DispatchQueue.main.async {
                self.showError()
            }
        case .success:
            loadingView.stopAnimation()
            tableView.reloadData()
        case .none:
            tableView.isHidden = true
        }
    }

    func openNew(next: UIViewController) {
        present(next, animated: true, completion: nil)
    }
}
// MARK: UITableViewDataSource, UITableViewDataSource
extension MoviesViewController: UITableViewDataSource, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == moviesViewModel.getCount() - 1 {
            moviesViewModel.updateView()
        }
    }

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
}
