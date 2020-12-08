import SwiftUI

struct CharacterListDetailsView: View {
    var name:String
    var item: OwnerCharacter
    var id:Int
    @ObservedObject var viewModel : CharacterListDetailsViewModel
    
    init(name:String,item: OwnerCharacter,id:Int) {
        viewModel = CharacterListDetailsViewModel(itemOwner: item, id: id)
        self.item = item
        self.name = name
        self.id = id
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16.0) {
                UrlImageView(urlString: item.avatarUrl)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5)
                Divider()
                HStack(alignment: .firstTextBaseline, spacing: 32) {
                    VStack {
                        Text(item.login ?? "")
                        Divider()
                        Text(viewModel.item?.fullName ?? "")
                    }
                    VStack {
                        Text(viewModel.item?.owner.type ?? "")
                        Divider()
                        Text(viewModel.dateString ?? "")
                    }
                }
                Spacer()
            }.padding([.top],8)
        }
        .onAppear {
            self.viewModel.getCharacterListDetails()
        }
        .navigationBarTitle(self.name.capitalized)
    }
    
}

struct CharacterListDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListDetailsView(name: "", item: OwnerCharacter(login: "", id: 0, avatarUrl: "", url: "", type: "", createdAt: ""), id: 0)
    }
}
