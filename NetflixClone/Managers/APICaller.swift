//
//  APICaller.swift
//  NetflixClone
//
//  Created by Kailash Bora on 22/04/24.
//

import Foundation

struct Constants {
    #warning("Never push API_KEY to github repo. Later will store the key in a more secure place.")
    static let apiKey = "***"
    static let baseUrl = "https://api.themoviedb.org"
    static let Youtube_API_KEY = "***"
    static let youtubeBaseUrl = "https://www.googleapis.com/youtube/v3/search"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    private init() {}

    func getTrendingMovies(completionHandler: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.apiKey)")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching failed with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func getTrendingTV(completionHandler: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.apiKey)")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching failed with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func getUpcomingMovies(completionHandler: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.apiKey)&language=en-US&page=1")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching failed with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func getPopularMovies(completionHandler: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.apiKey)&language=en-US&page=1")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching failed with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func getTopRatedMovies(completionHandler: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching failed with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func getDiscoverMovies(completionHandler: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.apiKey)&language=en-US&page=1")
        else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { discoverMovies, httpResponse, error in
            guard let data = discoverMovies,
                  error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Failed to fetch discover movies with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

    func searchQuery(with query: String, completionHandler: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.apiKey)&query=\(query)") else {
            return
        }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { discoverMovies, httpResponse, error in
            guard let data = discoverMovies,
                  error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingMoviesTitle.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Failed to fetch discover movies with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
        
    }

    func getMovies(with query: String, completionHandler: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        guard let url = URL(string: "\(Constants.youtubeBaseUrl)?q=\(query)&key=\(Constants.Youtube_API_KEY)")
        else { return }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { discoverMovies, httpResponse, error in
            guard let data = discoverMovies,
                  error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completionHandler(.success(results.items.first!))
            } catch {
                print("Failed to fetch discover movies with error: \(error.localizedDescription)")
                completionHandler(.failure(APIError.failedToGetData))
            }
        }.resume()
    }

//    func getMoviesOTT(with query: String, completionHandler: @escaping (Result<[SearchResult], Error>) -> Void) {
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//            return
//        }
//        let headers = [
//            "X-RapidAPI-Key": "",
//            "X-RapidAPI-Host": "ott-details.p.rapidapi.com"
//        ]
//        
//        guard let url = URL(string: "https://ott-details.p.rapidapi.com/search?title=\(query)") else { return }
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.allHTTPHeaderFields = headers
//            
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data, error == nil else { return }
//            do {
//                let result = try JSONDecoder().decode(SearchResponse.self, from: data)
//                completionHandler(.success(result.results ?? [SearchResult]()))
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
}
