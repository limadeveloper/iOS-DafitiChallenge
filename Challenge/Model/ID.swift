//
//  ID.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

import Foundation

struct ID {
    
    let imdb: String?
    let slug: String?
    let tmdb: Int?
    let trakt: Int?
    
    init(json: JSON?) {
        imdb = json?[Keys.imdb] as? String
        slug = json?[Keys.slug] as? String
        tmdb = json?[Keys.tmdb] as? Int
        trakt = json?[Keys.trakt] as? Int
    }
    
    struct Keys {
        static let imdb = "imdb"
        static let slug = "slug"
        static let tmdb = "tmdb"
        static let trakt = "trakt"
    }
}
