import SwiftUI

struct RepositoriesListDetailsView: View {
    var name:String
    var item: OwnerCharacter
    var id:Int
    @ObservedObject var viewModel : RepositoriesListDetailsViewModel
    
    init(name:String,item: OwnerCharacter,id:Int) {
        viewModel = RepositoriesListDetailsViewModel(id: id)
        self.item = item
        self.name = name
        self.id = id
    }
    
    var body: some View {
        LoadingView(isShowing: .constant($viewModel.isLoading.wrappedValue)) {
            GeometryReader { gp in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16.0) {
                        UrlImageView(urlString: self.viewModel.item?.owner.avatarUrl ?? "")
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.5)
                        Divider()
                        VStack(spacing: 8) {
                            VStack(spacing: 8) {
                                HStack(alignment: .center, spacing: 4) {
                                    Text("login:  ")
                                    Text(self.item.login ?? "")
                                }
                                Divider()
                                HStack(alignment: .center, spacing: 4) {
                                    Text("full Name:  ")
                                    Text(self.viewModel.item?.fullName ?? "")
                                }
                            }
                            Divider()
                            VStack(spacing: 8) {
                                HStack(alignment: .center, spacing: 4) {
                                    Text("Type:  ")
                                    Text(self.viewModel.item?.owner.type ?? "")
                                    
                                }
                                Divider()
                                HStack(alignment: .center, spacing: 4) {
                                    Text("Created At:  ")
                                    Text(self.viewModel.dateString ?? "")
                                }
                            }
                        }
                        Spacer()
                    }.padding([.top],8)
                }
            }
            .onAppear {
                self.viewModel.getRepositoriesListDetails()
            }
            .navigationBarTitle(self.name.capitalized)
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(""),
                message: Text($viewModel.alertMessage.wrappedValue),
                primaryButton: .destructive(Text("Retry"), action: {
                    self.viewModel.getRepositoriesListDetails()
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    // do something
                })
            )
        }
        
    }
    
}

struct RepositoriesListDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListDetailsView(name: "", item: OwnerCharacter(login: "", id: 0, avatarUrl: "", url: "", type: "", createdAt: ""), id: 0)
    }
}
