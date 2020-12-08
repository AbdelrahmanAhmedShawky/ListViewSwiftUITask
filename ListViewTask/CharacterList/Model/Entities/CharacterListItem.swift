import Foundation

struct CharacterListItem: Codable,Identifiable {
    
   // let id = UUID()
    let id: Int
    let name: String
    let fullName: String
    let url: String
    //let description:String
    let owner:OwnerCharacter
    //let createdAt:String
    
}

struct CharacterListItem2: Codable,Identifiable {
    
    let id: Int
    let name: String
    let fullName: String
    let owner:OwnerCharacter
    let createdAt:String
    
}

struct CharacterSearchListItem: Codable {
    
    let totalCount:Float
    let incompleteResults: Bool
    let items:[CharacterListItem]
    
}
