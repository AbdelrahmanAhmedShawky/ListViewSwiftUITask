//
//  CharacterEndPoints.swift
//  ListViewTask
//
//  Created by Abdelrahman Shawky on 12/7/20.
//  Copyright © 2020 Abdelrahman Shawky. All rights reserved.
//

import Foundation

enum CharacterEndPoints {
    case characterList
    case characterUrl(String)
    case characterListDetail(String)
}

extension CharacterEndPoints: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .characterList:
            guard let url = URL(string: "https://api.github.com/repositories")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .characterUrl(let url):
            
            guard let url = URL(string: url)
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
            
        case .characterListDetail(let id):
            
            guard let url = URL(string: "https://api.github.com/repositories/\(id)")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
    }
    
}
