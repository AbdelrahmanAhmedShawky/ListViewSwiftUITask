import Foundation
import Combine

protocol RepositoriesListDetailsApiService {
    var apiSession: APIService {get}
    func getRepositoriesListDetails(id:String) ->AnyPublisher<RepositoriesListDetailsItem,ApiErorr>
}

extension RepositoriesListDetailsApiService {
    
    func getRepositoriesListDetails(id:String) -> AnyPublisher<RepositoriesListDetailsItem,ApiErorr> {
        return apiSession.request(with: RepositoriesEndPoints.repositoriesListDetail(id))
        .eraseToAnyPublisher()
    }
}
