import Foundation
import Combine
import UIKit

class RepositoriesListViewModel: ObservableObject,RepositoriesListService {
    var apiSession: APIService
    
    @Published var repositoryList = [RepositoriesListItem]()
    @Published var repositoryitemsList = [OwnerCharacter]()
    
    @Published var items: [RepositoriesListItem] = []
    
    @Published var searchRepositoryListItems = [RepositoriesListItem]()
    
    @Published var isLoading: Bool
    
    @Published var showAlert: Bool
    
    @Published var alertMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var searchTerm: String = ""
    
    static private var itemsPerPage = 10
    
    private var start = -RepositoriesListViewModel.itemsPerPage
    private var stop = -1
    private var maxData = 10
    
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isLoading = false
        showAlert = false
    }
    
    
    private func incrementPaginationIndices() {
        
        start += RepositoriesListViewModel.itemsPerPage
        stop += RepositoriesListViewModel.itemsPerPage
        
        stop = min(maxData, stop)
    }
    
    private func getRepositoriesList(completion: (() -> Void)? = nil) {
    
        isLoading = true
        let cancellable = self.getRepositoriesList().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.showAlert = true
                print("Handle error: \(error)")
                self.alertMessage = error.localizedDescription
                completion?()
            case .finished:
                self.isLoading = false
                completion?()
                break
            }
        }) { (repositoryList) in
            self.isLoading = false
            self.showAlert = false
            self.repositoryList = repositoryList
            self.maxData = self.repositoryList.count
            completion?()
        }
        cancellables.insert(cancellable)
    }
    
    
    private func retrieveDataFromAPI(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
                self.getRepositoriesList {
                    if self.start >= self.maxData-1 {
                        completion?()
                        
                    }else {
                        if !self.repositoryList.isEmpty {
                            for i in self.start...self.stop {
                                self.items.append(self.repositoryList[i])
                            }
                            completion?()
                        }else {
                            //completion?()
                        }
                    }
                }
        }
    }
    
    
    func getData(completion: (() -> Void)? = nil) {
        
        self.incrementPaginationIndices()
        retrieveDataFromAPI (completion: completion)
        
    }
    
    
    private func getRepositoriesDataNeeded(characterList:[RepositoriesListItem]?) {
        guard  let characterList = characterList  else {
            return
        }
        
        for item in characterList {
            if let url = item.owner.url {
                let cacellable = self.getRepositoriesDataNeeded(url: url)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            self.alertMessage = error.localizedDescription
                        case .finished:
                            break
                        }
                    }) { finalResult in
                        self.repositoryitemsList.append(finalResult)
                }
                cancellables.insert(cacellable)
            }
        }
        
    }
    
    func searchRepositoriesList() {
        let cancellable = self.searchRepositoriesList(searchText: searchTerm)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                    self.isLoading = false
                    if !self.searchTerm.isEmpty {
                        self.showAlert = true
                        self.alertMessage = error.localizedDescription
                    }
                case .finished:
                    self.isLoading = false
                    break
                }
            }) { finalResult in
                self.isLoading = false
                self.showAlert = false
                self.searchRepositoryListItems = finalResult.items
        }
        cancellables.insert(cancellable)
    }
    
}
