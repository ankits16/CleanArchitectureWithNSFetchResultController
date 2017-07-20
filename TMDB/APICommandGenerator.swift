//
//  APICommandGenerator.swift
//  TMDB
//
//  Created by ankit on 15/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation

protocol SecretKeyReader {
    func fetchSecretKey() -> String
}

protocol BaseURLStringProvider {
    func fetchBaseURLString() -> String
}


struct APICommandGenerator {
    private let  baseURLProvider : BaseURLStringProvider
    private let secretKeyReader : SecretKeyReader
    
    init(baseURLProvider : BaseURLStringProvider , secretKeyReader: SecretKeyReader) {
        self.baseURLProvider = baseURLProvider
        self.secretKeyReader = secretKeyReader
    }
    
    func popularCommandGenerator(pageNumber : Int) -> String {
        let baseURL = baseURLProvider.fetchBaseURLString()
        let secretKey = secretKeyReader.fetchSecretKey()
        let commandURLStr =  baseURL+"popular?api_key="+secretKey+"&language=en-US&page="+String(pageNumber)
        return commandURLStr
    }
    
    func movieDetailCommandGenerator(movieID : Int) -> String {
        let baseURL = baseURLProvider.fetchBaseURLString()
        let secretKey = secretKeyReader.fetchSecretKey()
        let commandURLStr =  baseURL+String(movieID)+"?api_key="+secretKey+"&language=en-US"
        return commandURLStr
    }
   
}

struct APIBase : BaseURLStringProvider {
    func fetchBaseURLString() -> String {
        return "https://api.themoviedb.org/3/movie/"
    }
}
struct SecretKey : SecretKeyReader{
    func fetchSecretKey() -> String {
        return "295748ef437849da1fac3241478c907b"
    }
}
