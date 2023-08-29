import CoreLocation

struct Coordinates: Decodable {
    let origin: Coordinate?
    let destination: Coordinate?
    
    enum CodingKeys: String, CodingKey {
        case origin = "from"
        case destination = "to"
    }
    
    struct Coordinate: Decodable {
        let latitude: Double?
        let longitude: Double?
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "long"
        }
    }
}
