import Foundation

struct Connection: Decodable {
    
    let origin: String?
    let destination: String?
    let locationsCoordinates: Coordinates?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case origin = "from"
        case destination = "to"
        case locationsCoordinates = "coordinates"
        case price
    }
}
