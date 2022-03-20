//
//  DetailsViewBuilder.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

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
