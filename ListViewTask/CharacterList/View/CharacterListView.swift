import SwiftUI
import Combine

struct CharacterListView: View {
    
   @ObservedObject var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(self.viewModel.characteritemsList) { item in
                Text(item.owner.login ?? "")
            }
            .navigationBarTitle("Test")
        }
        .onAppear {
            self.viewModel.getCharacterList()
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
