//
//  DetailsMovieViewModel.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//

import Foundation
final class DetailsMovieViewModel {
    weak var view: DetailsModuleViewInput? {
        didSet {
            view?.update(state: state)
        }
    }
    
    private let moviesService: MovieService
    private var currentMovie: Details?


    required init(moviesService: MovieService) {
        self.moviesService = moviesService
        state = .none
    }
    
    var state: MoviePresenterState {
        didSet {
            switch state {
            case .success(let movies):
                //allMovies = movies
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

extension DetailsMovieViewModel: DetailsModuleViewOutput {
    
    func loadData(index: Int, _ name: String) {
      
    }
    
}
