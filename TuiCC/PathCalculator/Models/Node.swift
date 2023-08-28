import GameplayKit

class Node: GKGraphNode {
    
    //MARK: - Properties
    
    let flightConnection: Connection
    
    //MARK: - Init
    
    init(flightConnection: Connection) {
        self.flightConnection = flightConnection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        flightConnection = .stub()
        super.init()
    }
}
