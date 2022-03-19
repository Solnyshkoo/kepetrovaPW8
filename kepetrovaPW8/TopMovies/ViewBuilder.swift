import Foundation
import UIKit
final class MoviesModuleBuilder {
    let viewController: MoviesViewController
    private let presenter: MoviesViewModel

    init(moviesService: MovieService) {
        presenter = MoviesViewModel(moviesService: moviesService)
        viewController = MoviesViewController(output: presenter)
        presenter.view = viewController
    }
}
