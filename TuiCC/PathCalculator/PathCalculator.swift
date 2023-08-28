import GameplayKit
import CoreLocation

actor PathCalculator {
    
    //MARK: - Properties
    
    private let graph = GKGraph()
    private var nodes = [Node]()
    private var paths = [Path]()
    
    var connections = [FlightConnection]()
    
    //MARK: - Init
    
    init() {}
    
    //MARK: - Public interface
    
    func updateConnections(_ connections: [FlightConnection]) {
        self.connections = connections
    }
    
    func generatePath(from origin: String, to destination: String) throws -> PathResult {
        paths.removeAll()
        if connections.isNotEmpty && nodes.isEmpty {
            processNodes(from: origin)
        }

        findPath(from: origin, to: destination)
        
        guard
            paths.isNotEmpty,
            let cheapestPath = paths.min(by: { $0.cumulativePrice < $1.cumulativePrice })
        else {
            throw AppError.noPathsAvailable
        }
        
        let result = PathResult(
            coordinates: cheapestPath.coordinates(),
            stopOvers: cheapestPath.getStopOvers(),
            price: cheapestPath.cumulativePrice
        )
        
        return result
    }
}

// MARK: - Private work

extension PathCalculator {
    
    /// Will convert every `Connection` into `Node` so the graph can process them
    /// Then it will add the possible connections into each node.
    private func processNodes(from origin: String) {
        nodes = connections.map { Node(flightConnection: $0) }
        
        for node in nodes {
            let possibleConnections = nodes.filter { element in
                node.flightConnection.destination == element.flightConnection.origin && // Has connection to node
                node.flightConnection.destination != origin // We don't want to go in circles
            }
            node.addConnections(to: possibleConnections, bidirectional: false)
        }
    }
    
    /// Will process all possible `Path`s between the two give locations
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
                let nodes = graph.findPath(from: origin, to: destination).compactMap { $0 as? Node }
                if nodes.isNotEmpty {
                    let path = Path(nodes: nodes)
                    paths.append(path)
                }
            }
        }
    }
}



