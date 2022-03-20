import Foundation
import UIKit

final class SearchViewModel {
    weak var view: SearchModuleViewInput? {
        didSet {
            view?.update(state: state)
        }
    }

    private let moviesService: MovieService
    private var allMovies: [Movie] = []
    private var pages: Int = 1

    required init(moviesService: MovieService) {
        self.moviesService = moviesService
        state = .none
    }

    var state: MoviePresenterState {
        didSet {
            switch state {
            case .success(let movies):
                allMovies = movies
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

extension SearchViewModel: SearchModuleViewOutput {
    func getCount() -> Int {
        return allMovies.count
    }

    func getDataMovie(indexPath: Int) -> Movie {
        allMovies[indexPath]
    }

    func getPages() -> Int {
        return pages
    }

    func MovieTapped(indexPath: Int) {
        let detailModule = DetailsViewBuilder(moviesService: moviesService, index: Int(allMovies[indexPath].id) )
        view?.openNew(next: detailModule.viewController)
    }

    func search(index: Int, _ name: String) {
        if !name.isEmpty {
            let text = name.replacingOccurrences(of: " ", with: "%20")
            state = .loading
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.moviesService.searchMovies(page: index, text: text) { [weak self] result in
                    switch result {
                    case .success(let movies, let pages):
                        DispatchQueue.main.async {
                            self?.pages = pages
                            self?.state = .success(movies)
                        }
                    case .failure(let error):
                        self?.state = .error(error)
                    }
                }
            }
        } else {
            state = .none
        }
    }
}
