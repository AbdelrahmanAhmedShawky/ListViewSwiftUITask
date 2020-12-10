import Foundation
import Combine
import UIKit

class RepositoriesListViewModel: ObservableObject,RepositoriesListService {
    
    var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var repositoryList = [RepositoriesListItem]()
    @Published var searchRepositoryList = [RepositoriesListItem]()
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    var searchTerm: String = ""
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isShowLoader = false
        isShowAlert = false
        self.getRepositoriesList()
    }

    func getRepositoriesList() {
        isShowLoader = true
        let cancellable = self.getRepositoriesList().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isShowLoader = false
                self.isShowAlert = true
                self.alertMessage = error.localizedDescription
            case .finished:
                self.isShowLoader = false
                break
            }
        }) { (repositoryList) in
            self.isShowLoader = false
            self.isShowAlert = false
            self.repositoryList = repositoryList
        }
        cancellables.insert(cancellable)
    }
        
    func searchRepositoriesList() {
        let cancellable = self.searchRepositoriesList(searchText: searchTerm)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    self.isShowLoader = false
                    if !self.searchTerm.isEmpty {
                        self.isShowAlert = true
                        self.alertMessage = error.localizedDescription
                    }
                case .finished:
                    self.isShowLoader = false
                    break
                }
            }) { finalResult in
                self.isShowLoader = false
                self.isShowAlert = false
                self.searchRepositoryList = finalResult.items
            }
        cancellables.insert(cancellable)
    }
        
}

