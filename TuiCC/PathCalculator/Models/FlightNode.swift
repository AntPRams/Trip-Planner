import GameplayKit

class FlightNode: GKGraphNode {
    let id: String
    let flightConnection: Connection
    
    init(id: String, flightConnection: Connection) {
        self.flightConnection = flightConnection
        self.id = id
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        let coordinates = Coordinates.Coordinate(latitude: 0, longitude: 0)
        self.flightConnection = Connection(origin: "", destination: "", locationsCoordinates: Coordinates(origin: coordinates, destination: coordinates), price: 0)
        super.init()
    }
}
