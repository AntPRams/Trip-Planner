import Foundation

struct Connection: Decodable {
    
    let id = UUID()
    
    let origin: String
    let destination: String
    let locationsCoordinates: Coordinates
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case origin = "from"
        case destination = "to"
        case locationsCoordinates = "coordinates"
        case price
    }
}

extension Connection: Hashable {
    static func == (lhs: Connection, rhs: Connection) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
