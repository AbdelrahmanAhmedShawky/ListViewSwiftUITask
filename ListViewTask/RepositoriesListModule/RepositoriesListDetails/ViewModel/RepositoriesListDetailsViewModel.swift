import Foundation
import Combine


class RepositoriesListDetailsViewModel:ObservableObject,RepositoriesListService {
    var apiSession: APIService
    
    private var cancellables = Set<AnyCancellable>()
    
    let id:Int
    
    @Published var item: RepositoriesListDetailsItem?
    
    @Published var dateString: String?
    
    @Published var isLoading: Bool
    
    @Published var showAlert: Bool
    
    @Published var alertMessage = ""
    
    init(id:Int,apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        self.id = id
        isLoading = false
        showAlert = false
        
    }
    
    func getRepositoriesListDetails() {
        isLoading = true
        let cancellable = self.getRepositoriesListDetails(id: "\(id)").sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isLoading = false
                self.showAlert = true
                print("Handle error: \(error)")
                self.alertMessage = error.localizedDescription
            case .finished:
                break
            }
        }) { item in
            self.item = item
            self.dateString = self.convertDateFormat(inputDate: item.createdAt)
            self.isLoading = false
            self.showAlert = false
        }
        self.cancellables.insert(cancellable)
    }
    
    private func convertDateFormat(inputDate: String) -> String? {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:'Z'"
        
        let oldDate = olDateFormatter.date(from: inputDate) ?? Date()
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MM/dd/yyyy"
        
        return convertDateFormatter.string(from: oldDate)
    }
}
