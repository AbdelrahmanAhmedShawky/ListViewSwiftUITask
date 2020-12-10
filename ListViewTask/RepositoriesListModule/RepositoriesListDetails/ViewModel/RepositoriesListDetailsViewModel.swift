import Foundation
import Combine

class RepositoriesListDetailsViewModel:ObservableObject,RepositoriesListDetailsApiService {
    var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var repositoriesListDetailsItem: RepositoriesListDetailsItem?
    @Published var dateString: String?
    var id:Int
    @Published var isShowLoader: Bool
    @Published var isShowAlert: Bool
    @Published var alertMessage = ""
    
    init(id:Int,apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        self.id = id
        isShowLoader = false
        isShowAlert = false
        
    }
    
    func getRepositoriesListDetails() {
        isShowLoader = true
        let cancellable = self.getRepositoriesListDetails(id: "\(id)").sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                self.isShowLoader = false
                self.isShowAlert = true
                self.alertMessage = error.localizedDescription
            case .finished:
                break
            }
        }) { item in
            self.repositoriesListDetailsItem = item
            self.dateString = self.convertDateFormat(inputDate: item.createdAt)
            self.isShowLoader = false
            self.isShowAlert = false
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
