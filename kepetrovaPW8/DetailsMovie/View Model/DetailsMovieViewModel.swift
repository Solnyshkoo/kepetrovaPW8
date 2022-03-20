//
//  DetailsMovieViewModel.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 20.03.2022.
//
import Foundation
import UIKit
final class DetailsMovieViewModel {
    weak var view: DetailsModuleViewInput? {
        didSet {
            loadData()
        }
    }
    
    private let moviesService: MovieService
    private var currentMovie: DetailsPresenter?
    private var currentIndex: Int

    required init(moviesService: MovieService, index: Int) {
        self.moviesService = moviesService
        currentIndex = index
        state = .none
    }
    
    var state: DetailMoviePresenterState {
        didSet {
            switch state {
            case .success(let movies):
                currentMovie = movies
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
    
    private func convert(data: Details) -> DetailsPresenter {
        return DetailsPresenter(adult: data.adult, budget: data.budget, genres: data.genres[0].name, id: data.id, originalTitle: data.originalTitle, overview: data.overview, image: loadImage(url: URL(string: data.posterPath)!), productionCompanies: data.productionCompanies[0].originCountry, productionCountries: data.productionCountries[0].name, releaseDate: data.releaseDate, spokenLanguages: createString(array: data.spokenLanguages), status: data.status, voteAverage: data.voteAverage, voteCount: data.voteCount)
    }
    
    func loadImage(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    func createString(array: [SpokenLanguage]) -> String {
        var k: String = ""
        for i in 0..<array.count - 1 {
            k += array[i].englishName
            k += ", "
        }
        k += array[array.count - 1].englishName
        return k
    }
}

extension DetailsMovieViewModel: DetailsModuleViewOutput {
    func getDataMovie() -> DetailsPresenter {
        currentMovie ?? DetailsPresenter()
    }
    
    func loadData() {
        state = .loading
        print(currentIndex)
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.moviesService.detailMovies(page: self.currentIndex) { [weak self] result in
                switch result {
                case .success(posts: let posts):
                    DispatchQueue.main.async {
                        let data = self?.convert(data: posts)
                        self?.state = .success(data ?? DetailsPresenter())
                    }
                case .failure(error: let error):
                    self?.state = .error(error)
                }
            }
        }
    }
}
