import SwiftUI
import Combine

struct CharacterListView: View {
    
    @ObservedObject var viewModel = CharacterListViewModel()
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        LoadingView(isShowing: .constant($viewModel.isLoading.wrappedValue)) {
            NavigationView {
                Group {
                    VStack {
                        // Search view
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                TextField("search", text: self.$viewModel.searchTerm, onEditingChanged: { isEditing in
                                    self.viewModel.isSearchBegin = true
                                    self.viewModel.getData()
                                    self.showCancelButton = true
                                }, onCommit: {
                                    self.viewModel.isSearchBegin = true
                                    self.viewModel.getData()
                                    self.showCancelButton = true
                                }).foregroundColor(.primary)
                                
                                Button(action: {
                                    UIApplication.shared.endEditing(true)
                                    self.viewModel.searchTerm = ""
                                    self.viewModel.isSearchBegin = false
                                    self.viewModel.searchCharacterListItems.removeAll()
                                    self.showCancelButton = false
                                }) {
                                    Image(systemName: "xmark.circle.fill").opacity(self.viewModel.searchTerm == "" ? 0 : 1)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)
                            
                            if self.showCancelButton  {
                                Button("Cancel") {
                                    UIApplication.shared.endEditing(true)
                                    self.viewModel.searchTerm = ""
                                    self.viewModel.searchCharacterListItems.removeAll()
                                     self.viewModel.isSearchBegin = false
                                    self.showCancelButton = false
                                }
                                .foregroundColor(Color(.systemBlue))
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarHidden(self.showCancelButton)
                        ListPagination(items: self.viewModel.items, offset: 8, pagination: self.viewModel.getData) { item in
                          CharacterListViewCell(name: item.name, item: item.owner, id: item.id)
                        }
                        .navigationBarTitle("Task")
                        .resignKeyboardOnDragGesture()
                    }
                    
                }}
                .onAppear {
                     self.viewModel.getData()
            }
        }.alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(""),
                message: Text($viewModel.alertMessage.wrappedValue),
                primaryButton: .destructive(Text("Retry"), action: {
                    UIApplication.shared.endEditing(true)
                    self.viewModel.searchTerm = ""
                     self.viewModel.isSearchBegin = false
                    self.viewModel.getData()
                    self.viewModel.searchCharacterListItems.removeAll()
                }),
                secondaryButton: .default(Text("Cancel"), action: {
                    // do something
                })
            )
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
