//
//  Movie.swift
//  NetflixClone
//
//  Created by Kailash Bora on 22/04/24.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

struct TrendingMovies: Codable {
    let result: [Movie]
}
