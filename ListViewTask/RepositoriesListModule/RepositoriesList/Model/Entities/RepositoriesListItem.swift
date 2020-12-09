import Foundation

struct RepositoriesListItem: Codable,Identifiable {
    
    let id: Int
    let name: String
    let fullName: String
    let url: String
    let owner:OwnerCharacter
     
}

struct RepositoriesSearchListItem: Codable {
    
    let totalCount:Float
    let incompleteResults: Bool
    let items:[RepositoriesListItem]
    
}
