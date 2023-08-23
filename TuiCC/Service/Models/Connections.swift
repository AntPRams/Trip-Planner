import CoreLocation

struct Connections: Decodable {
    let connections: [Connection]
}

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

struct Coordinates: Decodable {
    let origin: Coordinate
    let destination: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case origin = "from"
        case destination = "to"
    }
}

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
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
