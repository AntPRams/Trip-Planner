import Foundation

protocol MainViewModelInterface: ObservableObject {
    func fetchData()
    func calculatePaths(from origin: String, to destination: String)
}

class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceInterface
    
    @Published var connections = [Connection]()
    @Published var cities = [String]()
    
    init(networkProvider: ConnectionsServiceInterface = ConnectionsService()) {
        self.networkProvider = networkProvider
    }
    
    func fetchData() {
        Task {
            do {
                let connections = try await networkProvider.fetchConnections()
                self.connections = connections
                extractCities()
                print(self.connections)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func extractCities() {
        let allCities = connections.flatMap { model in
            [model.origin, model.destination]
        }
        
        cities = allCities.removingDuplicates()
    }
    
    func calculatePaths(from origin: String, to destination: String) {
        
    }
}
