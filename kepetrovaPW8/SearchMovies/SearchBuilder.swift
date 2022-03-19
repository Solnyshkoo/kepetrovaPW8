import Foundation
final class SearchBuilder {
    let viewController: SearchViewController
    private let presenter: SearchViewModel

    init(moviesService: MovieService) {
        presenter = SearchViewModel(moviesService: moviesService)
        viewController = SearchViewController(output: presenter)
        presenter.view = viewController
    }
}
