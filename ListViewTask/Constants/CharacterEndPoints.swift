import Foundation

enum CharacterEndPoints {
    case characterList
    case characterUrl(String)
    case characterListDetail(String)
    case searchCharacterList(String)
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
        case .searchCharacterList(let q):
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(q)")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
    }
    
}
