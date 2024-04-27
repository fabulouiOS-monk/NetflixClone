//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Kailash Bora on 27/04/24.
//

import Foundation 

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let channelId: String?
    let kind: String?
    let videoId: String?
}
