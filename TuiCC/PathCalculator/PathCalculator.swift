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
    
    func getCheapestPath(from origin: String, to destination: String) throws -> PathResult {
        flightPaths.removeAll()
        if connections.isNotEmpty && nodes.isEmpty {
            processNodes(from: origin)
        }
        
        try validateSearch(origin: origin, destination: destination)

        findPath(from: origin, to: destination)
        
        guard
            flightPaths.isNotEmpty,
            let cheapestPath = flightPaths.min(by: { $0.cumulativePrice < $1.cumulativePrice })
        else {
            throw AppError.noPathsAvailable
        }
        
        let result = PathResult(
            coordinates: cheapestPath.coordinates(),
            stopOvers: cheapestPath.getStopOvers(),
            price: String(cheapestPath.cumulativePrice)
        )
        
        return result
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
        nodes = connections.map { FlightNode(flightConnection: $0) }
        
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
                }
            }
        }
    }
    
    private func validateSearch(origin: String, destination: String) throws {
        switch (origin, destination) {
        case _ where origin.isEmpty && destination.isEmpty:
            throw AppError.pathMissing
        case _ where origin.isEmpty:
            throw AppError.originMissing
        case _ where destination.isEmpty:
            throw AppError.destinationMissing
        case _ where destination == origin:
            throw AppError.sameCityInBothFields
        default:
            return
        }
    }
}



