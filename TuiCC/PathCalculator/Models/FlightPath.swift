import CoreLocation

class FlightPath {
    
    //MARK: - Properties
    
    var nodes: [FlightNode]
    var cumulativePrice: Double {
        let values = nodes.compactMap { node in
            node.flightConnection.price
        }
        return values.reduce(0, +)
    }
    
    //MARK: - Init
        
    init(nodes: [FlightNode]) {
        self.nodes = nodes
    }
}

//MARK: - Public interface

extension FlightPath {
    func coordinates() -> [CLLocationCoordinate2D] {
        guard nodes.isNotEmpty else { return [] }
        
        var mapCoordinates = [CLLocationCoordinate2D]()
        if let origin = nodes.first {
            mapCoordinates.append(origin.flightConnection.locationsCoordinates.origin.locationCoordinate)
            mapCoordinates.append(origin.flightConnection.locationsCoordinates.destination.locationCoordinate)
        }
        
        let destinationsDroppingOrigin = Array(nodes.dropFirst()).compactMap { node in
            node.flightConnection.locationsCoordinates.destination.locationCoordinate
        }
        mapCoordinates.append(contentsOf: destinationsDroppingOrigin)
        
        return mapCoordinates
    }
}
