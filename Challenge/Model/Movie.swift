//
//  Movie.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

import Foundation

struct Movie {
    
    let genres: [String]?
    let homepageUrl: String?
    let id: ID?
    let language: String?
    let overview: String?
    let rating: NSNumber?
    let released: String?
    let runtime: Int?
    let tagline: String?
    let title: String?
    let trailerUrl: String?
    let updatedAt: String?
    let votes: Int?
    let year: Int?
    var image: Image?
    
    init(json: JSON?) {
        genres = json?[Keys.genres] as? [String]
        homepageUrl = json?[Keys.homepageUrl] as? String
        id = ID(json: json?[Keys.id] as? JSON)
        language = json?[Keys.language] as? String
        overview = json?[Keys.overview] as? String
        rating = json?[Keys.rating] as? NSNumber
        released = json?[Keys.released] as? String
        runtime = json?[Keys.runtime] as? Int
        tagline = json?[Keys.tagline] as? String
        title = json?[Keys.title] as? String
        trailerUrl = json?[Keys.trailerUrl] as? String
        updatedAt = json?[Keys.updatedAt] as? String
        votes = json?[Keys.votes] as? Int
        year = json?[Keys.year] as? Int
    }
    
    struct Keys {
        static let genres = "genres"
        static let homepageUrl = "homepage"
        static let id = "ids"
        static let language = "language"
        static let overview = "overview"
        static let rating = "rating"
        static let released = "released"
        static let runtime = "runtime"
        static let tagline = "tagline"
        static let title = "title"
        static let trailerUrl = "trailer"
        static let updatedAt = "updated_at"
        static let votes = "votes"
        static let year = "year"
    }
}
