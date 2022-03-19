//
//  SearchBuilder.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 19.03.2022.
//

import Foundation
final class SearchBuilder {
    let viewController: SearchViewController
    private let presenter: SearchViewModel
   
    init(moviesService: MovieService) {
        presenter = SearchViewModel(moviesService: moviesService)
        viewController = SearchViewController(output: presenter)
        presenter.view = viewController
//        presenter = MoviesViewModel(moviesService: moviesService)
//        viewController = MoviesViewController(output: presenter)
//        presenter.view = viewController
    }
}
