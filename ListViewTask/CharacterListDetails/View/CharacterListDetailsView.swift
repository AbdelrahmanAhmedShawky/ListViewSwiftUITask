import SwiftUI

struct CharacterListDetailsView: View {
    var name:String
    var item: OwnerCharacter
    var id:Int
    @ObservedObject var viewModel : CharacterListDetailsViewModel
    
    init(name:String,item: OwnerCharacter,id:Int) {
        viewModel = CharacterListDetailsViewModel(id: id)
        self.item = item
        self.name = name
        self.id = id
    }
    
    var body: some View {
        LoadingView(isShowing: .constant($viewModel.isLoading.wrappedValue)) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16.0) {
                    UrlImageView(urlString: self.item.avatarUrl)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5)
                    Divider()
                    HStack(alignment: .firstTextBaseline, spacing: 32) {
                        VStack {
                            Text(self.item.login ?? "")
                            Divider()
                            Text(self.viewModel.item?.fullName ?? "")
                        }
                        VStack {
                            Text(self.viewModel.item?.owner.type ?? "")
                            Divider()
                            Text(self.viewModel.dateString ?? "")
                        }
                    }
                    Spacer()
                }.padding([.top],8)
            }
            .onAppear {
                self.viewModel.getCharacterListDetails()
            }
            .navigationBarTitle(self.name.capitalized)
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(""),
                message: Text($viewModel.alertMessage.wrappedValue),
                primaryButton: .destructive(Text("Retry"), action: {
                    self.viewModel.getCharacterListDetails()
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    // do something
                })
            )
        }
        
    }
    
}

struct CharacterListDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListDetailsView(name: "", item: OwnerCharacter(login: "", id: 0, avatarUrl: "", url: "", type: "", createdAt: ""), id: 0)
    }
}
