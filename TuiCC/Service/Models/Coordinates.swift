import CoreLocation

struct Coordinates: Decodable {
    let origin: Coordinate
    let destination: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case origin = "from"
        case destination = "to"
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
}

extension Coordinates {
    
    static func stub(
        origin: Coordinate = .stub(),
        destination: Coordinate = .stub()
    ) -> Coordinates {
        
        Coordinates(
            origin: origin,
            destination: destination
        )
    }
}

extension Coordinates.Coordinate {
    
    static func stub(
        latitude: Double = .zero,
        longitude: Double = .zero
    ) -> Self {
        
        Coordinates.Coordinate(
            latitude: latitude,
            longitude: longitude
        )
    }
}
