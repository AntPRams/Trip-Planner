import Foundation
import SwiftUI

protocol MainViewModelInterface: ObservableObject {
    func fetchData()
    func calculatePaths(from origin: String, to destination: String)
    func findPossiblePaths(from origin: String, to destination: String)
}

class MainViewModel: MainViewModelInterface {
    
    private var networkProvider: ConnectionsServiceInterface
    
//    @Published var connections = [Connection]()
    @Published var cities = [String]()
    @Published var originText: String = ""
    var newConnections = [NewConnection]()
    
    
    var paths = [Path]()
    var conns = [NewConnection]()
    var didFind = false
    
    
    
    
    
    
    init(networkProvider: ConnectionsServiceInterface = ConnectionsService()) {
        self.networkProvider = networkProvider
    }
    
    func fetchData() {
//        Task {
//            do {
//                let connections = try await networkProvider.fetchConnections()
//                await MainActor.run {
////                    self.connections = connections
//                    extractCities()
//                    print(self.connections)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    
    private func extractCities() {
//        let allCities = connections.flatMap { model in
//            [model.origin, model.destination]
//        }
        
//        cities = allCities.removingDuplicates()
//        self.objectWillChange.send()
    }
    
    func searchCity(query: String) {
        
    }
    
    func calculatePaths(from origin: String, to destination: String) {
        Task {
            newConnections.removeAll()
            let connections = try await networkProvider.fetchConnections()
            let mappedConnections = connections.map(mapConnection)
            addConnections(to: mappedConnections, origin: origin)
            findPossiblePaths(from: origin, to: destination)
        }
    }
    
    func findPossiblePaths(from origin: String, to destination: String) {
        paths.removeAll()
        var visitedCities = Set<String>()
        if let connection = newConnections.first(where: { element in
            element.destination == destination && element.origin == origin
        }) {
            paths.append(Path(path: [connection], cost: connection.price))
        }
        
        let origins = newConnections.filter { origin == $0.origin }
        
        for orig in origins {
            visitedCities.removeAll()
            conns.removeAll()
            conns.append(orig)
            visitedCities.insert(orig.origin)
            visitedCities.insert(orig.destination)
            searchIn(connection: orig, for: destination, visitedCities: &visitedCities)
        }
        printPaths()
    }
    
    func searchIn(connection: NewConnection, for destination: String, visitedCities: inout Set<String>) {
        
        for connection in connection.connections {
            guard let lastDestination = conns.last?.destination else {
                conns.append(connection)
                continue
            }
            
            if connection.destination == destination {
                print("BINGO!!!!!!!!")
                var connsi = conns
                connsi.append(connection)
                paths.append(Path(path: connsi, cost: conns.map{$0.price}.reduce(0, +)))
                didFind = true
                continue
            } else if connection.connections.isEmpty && connection.destination != destination || visitedCities.contains(connection.destination) {
                continue
            } else if lastDestination == connection.origin  {
                visitedCities.insert(connection.destination)
                visitedCities.insert(connection.origin)
                print("SIGA")
                conns.append(connection)
                searchIn(connection: connection, for: destination, visitedCities: &visitedCities)
            }
        }
    }
}

extension MainViewModel {
    
    func mapConnection(_ connection: Connection) -> NewConnection {
        NewConnection(
            id: connection.id.uuidString,
            origin: connection.origin,
            destination: connection.destination,
            price: connection.price
        )
    }

    func addConnections(to connections: [NewConnection], origin: String) {
        for connection in connections {
            let possibleConnections = connections.filter {
                connection.destination == $0.origin && //Has connection
                connection.id != $0.id && //Not the same model
                $0.destination != origin //Will not go in circles
            }
            connection.connections.append(contentsOf: possibleConnections)
            newConnections.append(connection)
        }
    }

    func printPaths() {
        paths.forEach { path in
            print(path.getPath())
        }
    }
}

struct Path {
    var path: [NewConnection]
    var cost: Double
    
    func getPath() -> String {
        var text = String()
        for connection in path {
            text += " \(connection.origin) -> \(connection.destination) -> "
        }
        return text
    }
}

class NewConnection {
    var id: String
    var origin: String
    var destination: String
    var price: Double
    var visited: Bool = false
    
    var connections = [NewConnection]()
    
    init(id: String, origin: String, destination: String, price: Double) {
        self.id = id
        self.origin = origin
        self.destination = destination
        self.price = price
    }
}
