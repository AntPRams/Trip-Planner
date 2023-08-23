import Foundation

protocol MainViewModelInterface: ObservableObject {
    func fetchData()
    func calculatePaths(from origin: String, to destination: String)
}

class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceAPI
    
    var connections = [Connection]()
    
    init(networkProvider: ConnectionsServiceAPI = connectionsServiceAPIClient) {
        self.networkProvider = networkProvider
    }
    
    func fetchData() {
        Task {
            do {
                let connections = try await networkProvider.fetch()
                self.connections = connections
                print(self.connections)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func calculatePaths(from origin: String, to destination: String) {
        
    }
    
    
}
