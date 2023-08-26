import Foundation
import SwiftUI

protocol MainViewModelInterface: ObservableObject {
    func fetchData()
    func calculatePaths(from origin: String, to destination: String)
}

class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceInterface
    
    @Published var connections = [Connection]()
    @Published var cities = [String]()
    @Published var originText: String = ""
    @Published var destinationText: String = ""
    
    init(networkProvider: ConnectionsServiceInterface = ConnectionsService()) {
        self.networkProvider = networkProvider
    }
    
    func fetchData() {
        Task {
            do {
                let connections = try await networkProvider.fetchConnections()
                await MainActor.run {
                    self.connections = connections
                    extractCities()
                    print(self.connections)
                }
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
        self.objectWillChange.send()
    }
    
    func searchCity(query: String) {
        
    }
    
    func calculatePaths(from origin: String, to destination: String) {
        Task {
            let connections = try await networkProvider.fetchConnections()
            let calculator = PathCalculator(connections: connections)
            let cheapest = try await calculator.getCheapestPath(from: origin, to: destination)
            print(cheapest)
        }
    }
}
