import Foundation
import Combine

protocol CharacterListService {
    var apiSession: APIService {get}
    
    func getCharacterList() ->AnyPublisher<[CharacterListItem],ApiErorr>
    func getCharacterDataNeeded(url:String) ->AnyPublisher<OwnerCharacter,ApiErorr>
    func getCharacterListDetails(id:String) ->AnyPublisher<CharacterListItem2,ApiErorr>
    func searchCharacterList(searchText:String) ->AnyPublisher<CharacterSearchListItem,ApiErorr>
    
}

extension CharacterListService {
    
    func getCharacterList() ->AnyPublisher<[CharacterListItem],ApiErorr> {
        return apiSession.request(with: CharacterEndPoints.characterList)
            .eraseToAnyPublisher()
    }
    
    func getCharacterDataNeeded(url:String) -> AnyPublisher<OwnerCharacter,ApiErorr> {
        return apiSession.request(with: CharacterEndPoints.characterUrl(url))
        .eraseToAnyPublisher()
    }
    
    func getCharacterListDetails(id:String) -> AnyPublisher<CharacterListItem2,ApiErorr> {
        return apiSession.request(with: CharacterEndPoints.characterListDetail(id))
        .eraseToAnyPublisher()
    }
    
    func searchCharacterList(searchText:String) -> AnyPublisher<CharacterSearchListItem,ApiErorr> {
        return apiSession.request(with: CharacterEndPoints.searchCharacterList(searchText))
        .eraseToAnyPublisher()
    }
    
}
