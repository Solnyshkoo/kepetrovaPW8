//
//  ViewBilder.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 19.03.2022.
//

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
