import SwiftUI

struct CharacterListViewCell: View {
    var name:String
    var item: OwnerCharacter
    var id:Int
    var body: some View {
        NavigationLink(destination: CharacterListDetailsView(name: name, item: item, id: id)) {
        HStack(alignment: .top,spacing: 32, content: {
            UrlImageView(urlString: item.avatarUrl)
               .frame(width:50, height:100)
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                Text(item.login ?? "")
                Text(item.type ?? "")
            }
        }).padding(.all,8.0)
        }
    }
}

struct CharacterListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListViewCell(name: "", item: OwnerCharacter(login: "", id: 0, avatarUrl: "", url: "", type: "", createdAt: ""), id: 0)
    }
}
