//
//  Requests.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import Foundation
import Alamofire

struct Requests {
    
    private static func request(from url: URL, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, parameterEncoding: ParameterEncoding = JSONEncoding.default, timeout: TimeInterval = 10, completion: ((Any?, Error?, Int?) -> ())?) {
        if let headers = headers {
            Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers).validate().responseJSON { (response) in
                if let value = response.result.value, response.result.isSuccess {
                    completion?(value, nil, response.response?.statusCode)
                }else {
                    completion?(nil, response.result.error, response.response?.statusCode)
                }
            }
        }else {
            Alamofire.request(url).validate().responseJSON { (response) in
                if let value = response.result.value, response.result.isSuccess {
                    completion?(value, nil, response.response?.statusCode)
                }else {
                    completion?(nil, response.result.error, response.response?.statusCode)
                }
            }
        }
    }
    
    static func getMovies(page: Int, completion: ((Any?, String?) -> ())?) {
        
        let url = URL(string: "\(Constants.API.kURL.movies)/\(Constants.API.Parameters.kTrending)?\(Constants.API.Parameters.kPage)=\(page)&\(Constants.API.Parameters.kLimit)=\(Constants.API.Parameters.Limit.default)&\(Constants.API.Parameters.kExtended)=\(Constants.API.Parameters.Extended.vFull)")!
        
        let headers: HTTPHeaders = [
            Constants.API.Headers.kApiVersion: Constants.API.Headers.vApiVersion,
            Constants.API.Headers.kApiKey: Constants.API.traktClientId
        ]
        
        request(from: url, method: .get, headers: headers) { (resut, error, code) in
            completion?(resut, Constants.API.Errors.getErrorMessage(byCode: code ?? 0))
        }
    }
    
    static func getImages(for movie: Movie, completion: ((Any?, String?) -> ())?) {
        if let id = movie.id?.tmdb {
            let url = URL(string: "\(Constants.API.kURL.themoviedbMovies)/\(id)/\(Constants.API.Parameters.kImagesKey)?\(Constants.API.Parameters.kApiKey)=\(Constants.API.themoviedbApiKey)")!
            request(from: url) { (result, error, code) in
                completion?(result, error?.localizedDescription)
            }
        }else {
            completion?(nil, Constants.API.Errors.getErrorMessage(byCode: 400))
        }
    }
}
