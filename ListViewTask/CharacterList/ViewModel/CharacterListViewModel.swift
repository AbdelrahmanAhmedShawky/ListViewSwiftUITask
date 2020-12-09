import Foundation
import Combine
import UIKit

class CharacterListViewModel: ObservableObject,CharacterListService {
    var apiSession: APIService
    
    @Published var characterList = [CharacterListItem]()
    @Published var characteritemsList = [OwnerCharacter]()
    
    @Published var items: [CharacterListItem] = []
    
    @Published var searchCharacterListItems = [CharacterListItem]()
    
    @Published var isLoading: Bool
    
    @Published var showAlert: Bool
    
    @Published var alertMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var searchTerm: String = ""
    
    static private var itemsPerPage = 10
    private var start = -CharacterListViewModel.itemsPerPage
    private var stop = -1
    private var maxData = 10
    
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isLoading = false
        showAlert = false
    }
    
    
    private func incrementPaginationIndices() {
        
        start += CharacterListViewModel.itemsPerPage
        stop += CharacterListViewModel.itemsPerPage
        
        stop = min(maxData, stop)
    }
    
    private func getCharacterList(completion: (() -> Void)? = nil) {
    
        isLoading = true
        let cancellable = self.getCharacterList().sink(receiveCompletion: { result in
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
        }) { (characterList) in
            self.isLoading = false
            self.showAlert = false
            self.characterList = characterList
            self.maxData = self.characterList.count
            completion?()
        }
        cancellables.insert(cancellable)
    }
    
    
    private func retrieveDataFromAPI(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
                self.getCharacterList {
                    if self.start >= self.maxData-1 {
                        completion?()
                        
                    }else {
                        if !self.characterList.isEmpty {
                            for i in self.start...self.stop {
                                self.items.append(self.characterList[i])
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
    
    
    private func getCharacterDataNeeded(characterList:[CharacterListItem]?) {
        guard  let characterList = characterList  else {
            return
        }
        
        for item in characterList {
            if let url = item.owner.url {
                let cacellable = self.getCharacterDataNeeded(url: url)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            self.alertMessage = error.localizedDescription
                        case .finished:
                            break
                        }
                    }) { finalResult in
                        self.characteritemsList.append(finalResult)
                }
                cancellables.insert(cacellable)
            }
        }
        
    }
    
    func searchCharacterList() {
        let cancellable = self.searchCharacterList(searchText: searchTerm)
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
                self.searchCharacterListItems = finalResult.items
        }
        cancellables.insert(cancellable)
    }
    
}
