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
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    private init() {}

    func getTrendingMoview(completionHandler: @escaping (Result<[Movie], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.apiKey)")
        else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { trendingMovies, httpResponse, error in
            guard let data = trendingMovies, error == nil else { return }

            do {
                let results = try JSONDecoder().decode(TrendingMovies.self, from: data)
                completionHandler(.success(results.result))
            } catch {
                print("Fetching fai led with error: \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }.resume()
    }
}
