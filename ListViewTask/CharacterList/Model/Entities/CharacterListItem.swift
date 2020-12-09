import Foundation

struct CharacterListItem: Codable,Identifiable {
    
    let id: Int
    let name: String
    let fullName: String
    let url: String
    let owner:OwnerCharacter
     
}

struct CharacterSearchListItem: Codable {
    
    let totalCount:Float
    let incompleteResults: Bool
    let items:[CharacterListItem]
    
}
