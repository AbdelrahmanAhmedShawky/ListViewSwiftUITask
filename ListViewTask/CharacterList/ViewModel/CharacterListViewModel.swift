import Foundation
import Combine
import UIKit

class CharacterListViewModel: ObservableObject,CharacterListService {
    var apiSession: APIService
    
    @Published var characterList = [CharacterListItem]()
    @Published var characteritemsList = [CharacterItem]()
    
    var cancellables = Set<AnyCancellable>()
    
    
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
           // self.fetchdata()
        }
        cancellables.insert(cancellable)
    }
    
    func fetchdata() {
        for i in 0..<self.characterList.count {
            
            if let url = self.characterList[i].owner.url {
                getCharacterDataNeeded(url: url,imagUrl: self.characterList[i].owner.avatarUrl)
            }
        }
    }
    
    func getCharacterDataNeeded(url:String,imagUrl:String?) {
        let cacellable = self.getCharacterDataNeeded(url: url)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                   print("Handle error: \(error)")
                case .finished:
                    break
                }
            }) { finalResult in
                self.characteritemsList.append(CharacterItem(owner: finalResult, image: self.getCharacterImage(urlString: imagUrl ?? "")))
        }
        cancellables.insert(cacellable)
    }
    
    func getCharacterImage(urlString: String) -> UIImage? {
        var imageResult:UIImage?
        let cancellable = apiSession.requestImage(with: urlString)
            .sink(receiveCompletion: { (result) in
                print(result)
            }) { (image) in
                imageResult = image
        }
        cancellables.insert(cancellable)
        return imageResult
    }
    
}
