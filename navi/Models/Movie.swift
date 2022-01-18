//
//  Movie.swift
//  navi
//
//  Created by Даня on 04.01.2022.
//

import Foundation

struct ResultMovies: Hashable, Codable{
    let results: [Movie]
}

// Модель данных Movie

struct Movie: Hashable, Codable{
    
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
    
    private enum CodingKeys : String, CodingKey {
        case id, overview
        case mediaType = "media_type"
        case originalName = "original_name"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
}
