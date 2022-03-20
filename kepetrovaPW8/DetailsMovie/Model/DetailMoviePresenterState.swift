//
//  DetailMoviePresenterState.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

import Foundation
enum DetailMoviePresenterState {
    case none
    case loading
    case success(DetailsPresenter)
    case error(Error)
}
