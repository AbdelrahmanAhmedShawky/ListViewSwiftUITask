import Foundation
import Combine
import UIKit

class CharacterListViewModel: ObservableObject,CharacterListService {
    var apiSession: APIService
    
    @Published var characterList = [CharacterListItem]()
    @Published var characteritemsList = [OwnerCharacter]()
    
    @Published var searchCharacterListItems = [CharacterListItem]()
    
    @Published var isLoading: Bool
    
    @Published var showAlert: Bool
    
     @Published var alertMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var searchTerm: String = ""
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        isLoading = false
        showAlert = false
    }
    
    func getCharacterList() {
        isLoading = true
        let cancellable = self.getCharacterList().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.showAlert = true
                print("Handle error: \(error)")
                self.alertMessage = error.localizedDescription
            case .finished:
                self.isLoading = false
                break
            }
        }) { (characterList) in
            self.isLoading = false
            self.showAlert = false
            self.characterList = characterList
        }
        cancellables.insert(cancellable)
    }
    
    
    func getCharacterDataNeeded(characterList:[CharacterListItem]?) {
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
