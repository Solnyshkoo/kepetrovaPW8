//
//  Movie.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import Foundation
import UIKit
class Movie {
    let title: String
    let posterPath: String
    var poster: UIImage? = nil
    
    init(title: String, path: String) {
        self.title = title
        self.posterPath = path
    }
}
