import Foundation
import UIKit

struct OwnerCharacter:Codable {
    
    let login: String?
    let id: Int?
    let avatarUrl: String?
    let url: String?
    let type: String?
    let createdAt:String?
    
   // let imageView:UIImage?

}

struct CharacterItem {
    let owner:OwnerCharacter?
    let image:UIImage?
}
