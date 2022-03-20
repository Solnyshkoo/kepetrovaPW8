import Foundation
import UIKit
class Movie {
    let title: String
    let posterPath: String
    let id: Int
    var poster: UIImage?

    init(title: String, path: String, id: Int) {
        self.title = title
        self.posterPath = path
        self.id = id
    }
}
