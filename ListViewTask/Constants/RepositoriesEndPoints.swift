import Foundation

enum RepositoriesEndPoints {
    case repositoriesList
    case repositoriesOwnerUrl(String)
    case repositoriesListDetail(String)
    case searchRepositoriesList(String)
}

extension RepositoriesEndPoints: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .repositoriesList:
            guard let url = URL(string: "\(Constants.BASEURL)/repositories")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        case .repositoriesOwnerUrl(let url):
            
            guard let url = URL(string: url)
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
            
        case .repositoriesListDetail(let id):
            
            guard let url = URL(string: "\(Constants.BASEURL)/repositories/\(id)")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        case .searchRepositoriesList(let q):
            guard let url = URL(string: "\(Constants.BASEURL)/search/repositories?q=\(q)")
                else {preconditionFailure("Invalid URL format")}
            
            let request = URLRequest(url: url)
            return request
        }
    }
    
}
