import CoreLocation

class Path {
    
    //MARK: - Properties
    
    var nodes: [Node]
    var cumulativePrice: Double {
        let values = nodes.compactMap { node in
            node.flightConnection.price
        }
        return values.reduce(0, +)
    }
    
    //MARK: - Init
        
    init(nodes: [Node]) {
        self.nodes = nodes
    }
}

//MARK: - Public interface

extension Path {
    func coordinates() -> [CLLocationCoordinate2D] {
        guard nodes.isNotEmpty else { return [] }
        
        var mapCoordinates = [CLLocationCoordinate2D]()
        if let origin = nodes.first {
            mapCoordinates.append(origin.flightConnection.originCoordinates)
            mapCoordinates.append(origin.flightConnection.destinationCoordinates)
        }
        
        let destinationsDroppingOrigin = Array(nodes.dropFirst()).compactMap { node in
            node.flightConnection.destinationCoordinates
        }
        mapCoordinates.append(contentsOf: destinationsDroppingOrigin)
        
        return mapCoordinates
    }
    
    func getStopOvers() -> [[String]] {
        nodes.map { (node: Node) in
            [node.flightConnection.origin, node.flightConnection.destination]
        }
    }
}
