import CoreLocation

struct FlightConnection {
    var price: Double
    var origin: String
    var destination: String
    var originCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
}

extension FlightConnection {
    
    static func map(_ connection: Connection?) -> Self? {
        guard
            let connection,
            let price = connection.price,
            let origin = connection.origin,
            let destination = connection.destination,
            let coordinates = connection.locationsCoordinates,
            let originLatCoordinates = coordinates.origin?.latitude,
            let originLonCoordinates = coordinates.origin?.longitude,
            let destinationLatCoordinates = coordinates.destination?.latitude,
            let destinationLonCoordinates = coordinates.destination?.longitude
        else { return nil }
            
        return FlightConnection(
            price: price,
            origin: origin,
            destination: destination,
            originCoordinates: CLLocationCoordinate2D(
                latitude: originLatCoordinates,
                longitude: originLonCoordinates
            ),
            destinationCoordinates: CLLocationCoordinate2D(
                latitude: destinationLatCoordinates,
                longitude: destinationLonCoordinates
            )
        )
    }
    
    static func stub(
        price: Double = .zero,
        origin: String = "origin-stub",
        destination: String = "destination-stub",
        originCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 1,
            longitude: 2
        ),
        destinationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: 3,
            longitude: 4
        )
    ) -> Self {
        
        FlightConnection(
            price: price,
            origin: origin,
            destination: destination,
            originCoordinates: originCoordinates,
            destinationCoordinates: destinationCoordinates
        )
    }
}
