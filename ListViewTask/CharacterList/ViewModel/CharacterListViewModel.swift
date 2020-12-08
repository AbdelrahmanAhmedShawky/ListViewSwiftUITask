import Foundation
import Combine
import UIKit

class CharacterListViewModel: ObservableObject,CharacterListService {
    var apiSession: APIService
    
    @Published var characterList = [CharacterListItem]()
    @Published var characteritemsList = [OwnerCharacter]()
    
    @Published var searchCharacterListItems = [CharacterListItem]()
    private var cancellables = Set<AnyCancellable>()
    
    var searchTerm: String = ""
    
    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        
    }
    
    func getCharacterList() {
        let cancellable = self.getCharacterList().sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                print("Handle error: \(error)")
            case .finished:
                break
            }
        }) { (characterList) in
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
                            print("Handle error: \(error)")
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
                case .finished:
                    break
                }
            }) { finalResult in
                print(finalResult.incompleteResults)
                self.searchCharacterListItems = finalResult.items
            }
        cancellables.insert(cancellable)
    }
            
}
