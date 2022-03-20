import Foundation
import Foundation
final class DetailsViewBuilder {
    let viewController: DetailsMovieViewController
    private let presenter: DetailsMovieViewModel

    init(moviesService: MovieService, index: Int) {
        presenter = DetailsMovieViewModel(moviesService: moviesService, index: index)
        viewController = DetailsMovieViewController(output: presenter)
        presenter.view = viewController
    }
}
