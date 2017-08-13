//
//  Image.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation

class Image {
    
    var selectedUrl: URL?
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
    
    enum ImageType {
        case poster
        case backdrop
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

extension Image {
    
    func getBestImagesByWidth(min: Double = 700, max: Double = 1500, type: ImageType = .poster) -> [String]? {
        
        var imagesWidth = self.posters?.map({ $0.width ?? -1 }).filter({ $0 != -1 }).sorted(by: { Int($0) < Int($1) })
        
        if type == .backdrop {
            var imagesWidth = self.backdrops?.map({ $0.width ?? -1 }).filter({ $0 != -1 }).sorted(by: { Int($0) < Int($1) })
        }
        
        var bestWidth: NSNumber {
            if let width = imagesWidth?.filter({ Double($0) > min && Double($0) < max }).first {
                return width
            }else {
                return imagesWidth?.first ?? 0
            }
        }
        
        let filter = (type == .poster ? self.posters : self.backdrops)?.filter({ $0.width == bestWidth })
        let urls = filter?.map({ $0.url ?? "-" }).filter({ $0 != "-" })
        
        return urls
    }
}
