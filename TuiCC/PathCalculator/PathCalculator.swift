import GameplayKit
import CoreLocation

actor PathCalculator {
    private let graph = GKGraph()
    private var nodes = [FlightNode]()
    private var flightPaths = [FlightPath]()
    
    var connections: [Connection]
    var origin: String
    
    init(connections: [Connection], origin: String) {
        self.connections = connections
        self.origin = origin
    }
    
    func updateOrigin(_ newOrigin: String) {
        self.origin = newOrigin
        processNodes()
    }
    
    func updateConnections(_ connections: [Connection], _ newOrigin: String? = nil) {
        self.connections = connections
        guard let newOrigin else {
            processNodes()
            return
        }
        updateOrigin(newOrigin)
        
    }
    
    func getCheapestPath(to destination: String) -> (price: Double, coordinates: [CLLocationCoordinate2D]) {
        
        return (price: 0, coordinates: [])
    }
    
    func printPath(_ path: [GKGraphNode]) {
        path.compactMap({ $0 as? FlightNode}).forEach { (node: FlightNode) in
            print("\(node.flightConnection.origin) -> \(node.flightConnection.destination)")
        }
    }

    func printCost(for path: [GKGraphNode]) {
        let values = path.compactMap({ $0 as? FlightNode}).compactMap { node in
            node.flightConnection.price
        }
        print(values.reduce(0, +))
    }
}

// MARK: - Private work

extension PathCalculator {
    private func processNodes() {
        let temporaryNodes = connections.map { FlightNode(id: $0.id.uuidString, flightConnection: $0) }
        
        for node in temporaryNodes {
            let possibleConnections = connections.filter { connection in
                node.flightConnection.destination == connection.origin && // Has connection
                connection.destination != origin // We won't go in circles
            }
            
            for possibleConnection in possibleConnections {
                if let nodeConnection = temporaryNodes.first(where: { element in
                    element.id == possibleConnection.id.uuidString
                }) {
                    node.addConnections(to: [nodeConnection], bidirectional: false) //addConnection(to: nodeConnection, price: Float(nodeConnection.flightConnection.price))
                }
            }
        }
        self.nodes = temporaryNodes
    }
    
    private func findPath(to destination: String) {
        let possibleNodesToOrigin = nodes.filter { node in
            node.flightConnection.origin == origin
        }
        let possibleNodesToDestination = nodes.filter { node in
            node.flightConnection.destination == destination
        }
        
        for origin in possibleNodesToOrigin {
            for destination in possibleNodesToDestination {
                let nodes = graph.findPath(from: origin, to: destination).compactMap { $0 as? FlightNode }
                let path = FlightPath(nodes: nodes)
                flightPaths.append(path)
                printPath(nodes)
                printCost(for: nodes)
            }
        }
    }
}



