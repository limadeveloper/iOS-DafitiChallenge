//
//  Constants.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit
import Foundation

typealias JSON = [String: Any]

struct Constants {
    
    struct API {
        
        static let traktClientId = "e81f57e3839e768a3325151c7add0eb87d471d90ba504fdaf1b703878e5dfa1b"
        static let themoviedbApiKey = "f4de9abba56bf9cd84fa8bb57836137a"
        
        struct kURL {
            
            /// Documentation: [Trakt API](http://docs.trakt.apiary.io/#introduction/required-headers)
            static let movies = "https://api.trakt.tv/movies"
            static let themoviedbMovies = "https://api.themoviedb.org/3/movie"
            static let themoviedbImage = "https://image.tmdb.org/t/p/w1000"
        }
        
        struct Parameters {
            
            static let kPage = "page"
            static let kLimit = "limit"
            static let kExtended = "extended"
            static let kQuery = "query"
            static let kYears = "years"
            static let kGenres = "genres"
            static let kClientId = "client_id"
            static let kTrending = "trending"
            static let kApiKey = "api_key"
            static let kImagesKey = "images"
            
            struct Limit {
                static let `default` = 20
            }
            
            struct Extended {
                static let vFull = "full"
                static let vMetadata = "metadata"
                static let vImages = "images"
            }
            
            struct Genres {
                static let kType = "type"
            }
        }
        
        struct Headers {
            static let kContentType = "Content-type"
            static let vApplicationJson = "application/json"
            static let kApiKey = "trakt-api-key"
            static let kApiVersion = "trakt-api-version"
            static let vApiVersion = "2"
        }
        
        struct Errors {
            
            static func getErrorMessage(byCode: Int) -> String? {
                
                var message = "Something wrong, try again in a few minutes"
                
                switch byCode {
                case 400: message = "Bad Request - request couldn't be parsed"
                case 401: message = "Unauthorized - OAuth must be provided"
                case 403: message = "Forbidden - invalid API key or unapproved app"
                case 404: message = "Not Found - method exists, but no record found"
                case 405: message = "Method Not Found - method doesn't exist"
                case 409: message = "Conflict - resource already created"
                case 412: message = "Precondition Failed - use application/json content type"
                case 422: message = "Unprocessible Entity - validation errors"
                case 429: message = "Rate Limit Exceeded"
                case 500: message = "Server Error"
                case 503, 504: message = "Service Unavailable - server overloaded (try again in 30s)"
                case 520 ... 522: message = "Service Unavailable - Cloudflare error"
                default:
                    return nil
                }
                
                return "\(message), Error Code: (\(byCode))"
            }
        }
    }
    
    struct Text {
        static let error = "Error"
        static let done = "Ok"
    }
    
    struct Color {
        static let dark = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
