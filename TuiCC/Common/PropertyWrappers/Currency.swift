import Foundation
import Combine

@propertyWrapper
struct Currency {
    private var value: String
    
    private let subject = PassthroughSubject<String, Never>()
    
    public init(wrappedValue: String) {
        value = wrappedValue
    }
    
    public var wrappedValue: String {
        get { value }
        set {
            value = formatValue(from: newValue)
            subject.send(value)
        }
    }
    
    private func formatValue(from currentValue: String) -> String {
        let localeIdentifier = Locale.preferredLanguages[0]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = localeIdentifier
        formatter.locale = Locale(identifier: localeIdentifier)
        
        guard
            let valueAsDouble = Double(value),
            let formattedString = formatter.string(from: valueAsDouble as NSNumber)
        else {
            assertionFailure("Failed to format value")
            return String()
        }
        
        return formattedString
    }
}
