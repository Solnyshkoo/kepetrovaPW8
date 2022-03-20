import Foundation
import UIKit
enum ObtainPostsResult {
    case success(posts: [Movie], page: Int)
    case failure(error: Error)
}

enum ObtainPostsDetailResult {
    case success(posts: Details)
    case failure(error: Error)
}

final class MovieService {
    private let apiKey = "536251f247f9fc55b0d3fc56fc43d0e2"
    private var allPages = 1

    func loadMovies(page: Int, _ closure: @escaping (ObtainPostsResult) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ruRU&page=\(page)") else { return assertionFailure("some problems with url") }
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            var result: ObtainPostsResult
            guard
                let data = data,
                let post = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any],

                let results = post["results"] as? [[String: Any]],
                let pages = post["total_pages"] as? Int
            else {
                result = .failure(error: error!)
                return
            }

            let movies: [Movie] = results.map { item in
                let title = item["title"] as? String
                let imagePath = item["poster_path"] as? String
                let id = item["id"] as? Int

                return Movie(title: title ?? "", path: imagePath ?? "", id: id ?? 0)
            }
            result = .success(posts: movies, page: Int(pages))
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
                result = .success(posts: movies, page: Int(pages))
                closure(result)
            }
        }
        session.resume()
    }

    func searchMovies(page: Int, text: String, _ closure: @escaping (ObtainPostsResult) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(text)&page=\(page)") else { return assertionFailure("some problems with url") }
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            var result: ObtainPostsResult
            guard
                let data = data,
                let post = try? JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any],
                let results = post["results"] as? [[String: Any]],
                let pages = post["total_pages"] as? Int
            else {
                result = .failure(error: error!)
                return
            }
            let movies: [Movie] = results.map { item in
                let title = item["original_title"] as? String
                let imagePath = item["poster_path"] as? String
                let id = item["id"] as? Int
                return Movie(title: title ?? "", path: imagePath ?? "", id: id ?? 0)
            }
            result = .success(posts: movies, page: pages)
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
                result = .success(posts: movies, page: pages)
                closure(result)
            }
            print(movies)
        }
        session.resume()
    }

    func detailMovies(page: Int, _ closure: @escaping (ObtainPostsDetailResult) -> Void) {
        print(page)
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(page)?api_key=\(apiKey)&language=en-US") else { return assertionFailure("some problems with url") }
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            var result: ObtainPostsDetailResult
            defer {
                closure(result)
            }
            let data = data
            do {
                let places = try? JSONDecoder().decode(Details.self, from: data!)
                print(places as Any)
                result = .success(posts: places!)
            } catch let DecodingError.dataCorrupted(context) {
                result = .failure(error: errSecInternalError as! Error)
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                result = .failure(error: errSecInternalError as! Error)
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                result = .failure(error: errSecInternalError as! Error)
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                result = .failure(error: errSecInternalError as! Error)
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                result = .failure(error: errSecInternalError as! Error)
                print("error: ", error)
            }
            guard
                let data = data,
                let post = try? JSONDecoder().decode(Details.self, from: data)
            else {
                result = .failure(error: error!)
                return
            }
            result = .success(posts: post)
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
