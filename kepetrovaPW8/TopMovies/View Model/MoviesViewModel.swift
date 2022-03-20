import Foundation

import UIKit
final class MoviesViewModel {
    weak var view: MoviesModuleViewInput? {
        didSet {
            updateView()
        }
    }

    private let moviesService: MovieService
    private var allMovies: [Movie] = []
    static var currentPages = 0
    private var allPages = 1

    required init(moviesService: MovieService) {
        self.moviesService = moviesService
        state = .none
    }

    var state: MoviePresenterState {
        didSet {
            switch state {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
                view?.update(state: .success(movies))
            case .error(let error):
                view?.update(state: .error(error))
            case .loading:
                view?.update(state: .loading)
            case .none:
                break
            }
        }
    }
}

extension MoviesViewModel: MoviesModuleViewOutput {
    func getCount() -> Int {
        print(allMovies)
        return allMovies.count
    }

    func getDataMovie(indexPath: Int) -> Movie {
        allMovies[indexPath]
    }

    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= allMovies.count
    }

    func updateView() {
        state = .loading
        MoviesViewModel.currentPages += 1
        if MoviesViewModel.currentPages <= allPages {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.moviesService.loadMovies(page: MoviesViewModel.currentPages) { [weak self] result in
                    switch result {
                    case .success(let movies, let page):
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self?.allPages = page
                            self?.state = .success(movies)
                        }
                    case .failure(let error):
                        self?.state = .error(error)
                    }
                }
            }
        }
    }

    func MovieTapped(indexPath: Int) {
        let detailModule = DetailsViewBuilder(moviesService: moviesService, index: allMovies[indexPath].id)
        print(allMovies[indexPath].id)
        view?.openNew(next: detailModule.viewController)
    }
}
