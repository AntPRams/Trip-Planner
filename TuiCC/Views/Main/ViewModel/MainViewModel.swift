import Foundation

protocol MainViewModelInterface: ObservableObject {
    func fetchData()
    func calculatePaths(from origin: String, to destination: String)
}

class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceInterface
    
    var connections = [Connection]()
    
    init(networkProvider: ConnectionsServiceInterface = ConnectionsService()) {
        self.networkProvider = networkProvider
    }
    
    func fetchData() {
        Task {
            do {
                let connections = try await networkProvider.fetchConnections()
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
