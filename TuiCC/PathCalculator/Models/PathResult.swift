import CoreLocation

struct PathResult {
    var coordinates: [CLLocationCoordinate2D]
    var stopOvers: [[String]]
    @Currency var price: String
}

extension PathResult {
    
    func stub(
        coordinates: [CLLocationCoordinate2D] = [],
        stopOvers: [[String]] = [[]],
        price: String = String()
    ) -> PathResult {
        
        PathResult(
            coordinates: coordinates,
            stopOvers: stopOvers,
            price: price
        )
    }
}
