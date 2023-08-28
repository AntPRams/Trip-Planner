import GameplayKit

class Node: GKGraphNode {
    
    //MARK: - Properties
    
    let flightConnection: FlightConnection
    
    //MARK: - Init
    
    init(flightConnection: FlightConnection) {
        self.flightConnection = flightConnection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        flightConnection = .stub()
        super.init()
    }
}
