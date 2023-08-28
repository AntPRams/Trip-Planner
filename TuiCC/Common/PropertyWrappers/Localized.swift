import Foundation
import Combine

@propertyWrapper
struct Localized {
    private var value: String
    
    private let subject = PassthroughSubject<String, Never>()
    
    public init(wrappedValue: String) {
        value = NSLocalizedString(wrappedValue, comment: "")
    }
    
    public var wrappedValue: String {
        get { value }
        set {
            value = NSLocalizedString(newValue, comment: "")
            subject.send(value)
        }
    }
}
