struct Connections: Decodable {
    let connections: [Connection]
}

extension Connections {
    
    static func stub(connections: [Connection] = [.stub()]) -> Connections {
        Connections(connections: connections)
    }
}
