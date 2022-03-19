import Foundation
import UIKit
class Movie {
    let title: String
    let posterPath: String
    let id: String
    var poster: UIImage?

    init(title: String, path: String, id: String) {
        self.title = title
        self.posterPath = path
        self.id = id
    }
}
