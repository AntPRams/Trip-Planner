import GameplayKit
import CoreLocation

actor PathCalculator {
    
    //MARK: - Properties
    
    private let graph = GKGraph()
    private var nodes = [FlightNode]()
    private var flightPaths = [FlightPath]()
    
    var connections = [Connection]()
    
    //MARK: - Init
    
    init() {}
    
    //MARK: - Public interface
    
    func updateConnections(_ connections: [Connection]) {
        self.connections = connections
    }
    
    func getCheapestPath(from origin: String, to destination: String) throws -> (price: Double, coordinates: [CLLocationCoordinate2D]) {
        if connections.isNotEmpty && nodes.isEmpty {
            processNodes(from: origin)
        }

        findPath(from: origin, to: destination)
        
        guard
            flightPaths.isNotEmpty,
            let cheapestPath = flightPaths.min(by: { $0.cumulativePrice < $1.cumulativePrice })
        else {
            throw AppError.noPathsAvailable
        }
        
        return (price: cheapestPath.cumulativePrice, coordinates: cheapestPath.coordinates())
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
    
    /// Will convert every `Connection` into `FlightNode` so the graph can process them
    /// Then it will add the possible connections into each node.
    private func processNodes(from origin: String) {
        nodes = connections.map { FlightNode(id: $0.id.uuidString, flightConnection: $0) }
        
        for node in nodes {
            let possibleConnections = nodes.filter { element in
                node.flightConnection.destination == element.flightConnection.origin && // Has connection to node
                node.flightConnection.destination != origin // We don't want to go in circles
            }
            node.addConnections(to: possibleConnections, bidirectional: false)
        }
    }
    
    /// Will process all possible `FlightPath`s between the two give locations
    ///
    /// - Parameters:
    ///   - origin: Origin city
    ///   - destination: Destination city
    private func findPath(from origin: String, to destination: String) {
        //Filter all nodes that match the requested origin
        let possibleNodesToOrigin = nodes.filter { node in
            node.flightConnection.origin == origin
        }
        //Filter all nodes that match the requested destination
        let possibleNodesToDestination = nodes.filter { node in
            node.flightConnection.destination == destination
        }
        
        //Calculate all possible paths between the two nodes
        for origin in possibleNodesToOrigin {
            for destination in possibleNodesToDestination {
                let nodes = graph.findPath(from: origin, to: destination).compactMap { $0 as? FlightNode }
                if nodes.isNotEmpty {
                    let path = FlightPath(nodes: nodes)
                    flightPaths.append(path)
                    printPath(nodes)
                    printCost(for: nodes)
                }
            }
        }
    }
}



