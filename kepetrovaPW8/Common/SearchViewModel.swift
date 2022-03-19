//
//  MoviesViewModel.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import Foundation
import UIKit

final class SearchViewModel {
    weak var view: SearchModuleViewInput? {
        didSet {
            updateView()
        }
    }

    private let moviesService: MovieService
    private var allMovies: [Movie] = []

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
    func updateView() {
        state = .loading
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.moviesService.loadMovies { [weak self] result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.state = .success(movies)
                    }
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        }
    }
   
}


extension SearchViewModel: SearchModuleViewOutput {
    func getCount() -> Int {
        print(allMovies)
        return allMovies.count
        
    }

    func getDataMovie(indexPath: Int) -> Movie {
        allMovies[indexPath]
    }


    
    func MovieTapped(section: Int) {}
}


