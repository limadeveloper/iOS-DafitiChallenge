//
//  Image.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

class Image {
    
    var backdrops: [TMDBMovieBackdrop]?
    var posters: [TMDBMoviePoster]?
    
    init(json: JSON?) {
        
        backdrops = [TMDBMovieBackdrop]()
        posters = [TMDBMoviePoster]()
        
        if let backdrops = json?[Keys.tmdbMovieBackdrop] as? [JSON] {
            for item in backdrops {
                self.backdrops?.append(TMDBMovieBackdrop(json: item))
            }
        }
        
        if let posters = json?[Keys.tmdbMoviePoster] as? [JSON] {
            for item in posters {
                self.posters?.append(TMDBMoviePoster(json: item))
            }
        }
    }
    
    struct Keys {
        static let tmdbMovieBackdrop = "backdrops"
        static let tmdbMoviePoster = "posters"
    }
}

extension Image {
    
    class TMDBMoviePoster {
        
        let height: NSNumber?
        let voteAverage: NSNumber?
        let voteCount: Int?
        let width: NSNumber?
        var url: String?
        
        init(json: JSON) {
            
            height = json[Keys.height] as? NSNumber
            voteAverage = json[Keys.voteAverage] as? NSNumber
            voteCount = json[Keys.voteCount] as? Int
            width = json[Keys.width] as? NSNumber
            
            if let filePath = json[Keys.filePath] {
                url = "\(Constants.API.kURL.themoviedbImage)\(filePath)"
            }
        }
        
        struct Keys {
            static let filePath = "file_path"
            static let height = "height"
            static let voteAverage = "vote_average"
            static let voteCount = "vote_count"
            static let width = "width"
        }
    }
    
    class TMDBMovieBackdrop: TMDBMoviePoster {}
}
