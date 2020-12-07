import SwiftUI
import Combine

struct CharacterListView: View {
    
   @ObservedObject var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(self.viewModel.characterList) { item in
                Text(item.name.capitalized)
            }
            .navigationBarTitle("Test")
        }
        .onAppear {
            self.viewModel.getCharacterList()
            self.viewModel.fetchdata()
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
