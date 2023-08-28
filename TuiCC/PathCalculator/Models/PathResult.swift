import CoreLocation

struct PathResult {
    var coordinates: [CLLocationCoordinate2D]
    var stopOvers: [[String]]
    var price: Double
    var formattedValue: String {
        formatValue(from: price)
    }
    
    init(coordinates: [CLLocationCoordinate2D], stopOvers: [[String]], price: Double) {
        self.coordinates = coordinates
        self.stopOvers = stopOvers
        self.price = price
    }
}

extension PathResult {
    
    func stub(
        coordinates: [CLLocationCoordinate2D] = [],
        stopOvers: [[String]] = [[]],
        price: Double = 0
    ) -> PathResult {
        
        PathResult(
            coordinates: coordinates,
            stopOvers: stopOvers,
            price: price
        )
    }
    
    private func formatValue(from currentValue: Double) -> String {
        let localeIdentifier = Locale.preferredLanguages[0]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "€"
        formatter.locale = Locale(identifier: localeIdentifier)
        
        guard
            let formattedString = formatter.string(from: currentValue as NSNumber)
        else {
            assertionFailure("Failed to format value")
            return String()
        }
        
        return formattedString
    }
}
