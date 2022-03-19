//
//  MovieService.swift
//  kepetrovaPW8
//
//  Created by Ksenia Petrova on 17.03.2022.
//

import Foundation
import UIKit
enum ObtainPostsResult {
    case success(posts: [Movie])
    case failure(error: Error)
}

final class MovieService {
    private let apiKey = "536251f247f9fc55b0d3fc56fc43d0e2"
    func loadMovies(_ closure: @escaping (ObtainPostsResult) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ruRU") else { return assertionFailure("some problems with url") }
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            var result: ObtainPostsResult

            guard
                let data = data,
                let post = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any],
                let results = post["results"] as? [[String: Any]]
            else {
                result = .failure(error: error!)
                return
            }
            let movies: [Movie] = results.map { item in
                let title = item["title"] as? String
                let imagePath = item["poster_path"] as? String
                let id = item["id"] as? String
                return Movie(title: title ?? "", path: imagePath ?? "", id: id ?? "")
            }
            result = .success(posts: movies)
            let group = DispatchGroup()
            for movie in movies {
                group.enter()
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    self.loadPosters(movie: movie, completion: { _ in
                        group.leave()
                    })
                }
            }
            group.notify(queue: .main) {
                result = .success(posts: movies)
                closure(result)
            }
        }
        session.resume()
    }
    
    private func loadPosters(movie: Movie, completion: @escaping (UIImage?) -> Void) {
        let poster = movie.posterPath
        guard
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(poster)")
        else {
            return completion(nil)
        }
        let session = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                return completion(nil)
            }
            
            movie.poster = image
            completion(image)
        }
        session.resume()
    }
}
