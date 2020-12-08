import SwiftUI
import Combine

struct CharacterListView: View {
    
    @ObservedObject var viewModel = CharacterListViewModel()
    @State private var showCancelButton: Bool = false

    var body: some View {
        NavigationView {
            Group {
                VStack {
                    // Search view
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("search", text: $viewModel.searchTerm, onEditingChanged: { isEditing in
                                self.showCancelButton = true
                                self.viewModel.searchCharacterList()
                            }, onCommit: {
                                print("onCommit")
                            }).foregroundColor(.primary)
                            
                            Button(action: {
                                UIApplication.shared.endEditing(true)
                                viewModel.searchTerm = ""
                                self.viewModel.searchCharacterListItems.removeAll()
                                self.showCancelButton = false
                            }) {
                                Image(systemName: "xmark.circle.fill").opacity(viewModel.searchTerm == "" ? 0 : 1)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.secondary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10.0)
                        
                        if showCancelButton  {
                            Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                viewModel.searchTerm = ""
                                self.viewModel.searchCharacterListItems.removeAll()
                                self.showCancelButton = false
                            }
                            .foregroundColor(Color(.systemBlue))
                        }
                    }
                    .padding(.horizontal)
                    .navigationBarHidden(showCancelButton)
                    List(viewModel.searchCharacterListItems.isEmpty ? self.viewModel.characterList : self.viewModel.searchCharacterListItems) { item in
                        CharacterListViewCell(name: item.name, item: item.owner, id: item.id)
                    }
                    .navigationBarTitle("Task")
                    .resignKeyboardOnDragGesture()
                }
                
            }}
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

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
