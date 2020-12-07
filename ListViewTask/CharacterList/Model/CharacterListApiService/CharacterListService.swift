import Foundation
import Combine

protocol CharacterListService {
    var apiSession: APIService {get}
    
    func getCharacterList() ->AnyPublisher<[CharacterListItem],ApiErorr>
    func getCharacterDataNeeded(url:String) ->AnyPublisher<OwnerCharacter,ApiErorr>
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
}
