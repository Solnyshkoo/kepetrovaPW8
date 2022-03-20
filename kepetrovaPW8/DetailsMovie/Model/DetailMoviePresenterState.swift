import Foundation
enum DetailMoviePresenterState {
    case none
    case loading
    case success(DetailsPresenter)
    case error(Error)
}
