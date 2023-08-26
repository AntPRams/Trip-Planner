import CoreLocation

class FlightPath {
    var nodes: [FlightNode]
    var price: Double {
        let values = nodes.compactMap { node in
            node.flightConnection.price
        }
        return values.reduce(0, +)
    }
        
    init(nodes: [FlightNode]) {
        self.nodes = nodes
    }
    
    func getCoordinates() -> [CLLocationCoordinate2D] {
        guard nodes.isEmpty else { return [] }
        
        let coordinates = nodes.compactMap { node in
            node.flightConnection.locationsCoordinates.destination
        }
        return []
    }
}
