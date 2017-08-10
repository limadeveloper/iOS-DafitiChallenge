//
//  Model.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

struct Model {
    
    var movie: Movie?
    let watchers: Int?
    
    struct Keys {
        static let movie = "movie"
        static let watchers = "watchers"
    }
    
    init(json: JSON?) {
        movie = Movie(json: json?[Keys.movie] as? JSON)
        watchers = json?[Keys.watchers] as? Int
    }
}
