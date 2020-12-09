import SwiftUI
import Combine

struct CharacterListView: View {
    
   @ObservedObject var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(self.viewModel.characterList) { item in
                CharacterListViewCell(name: item.name, item: item.owner, id: item.id)
            }
            .navigationBarTitle("Task")
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
