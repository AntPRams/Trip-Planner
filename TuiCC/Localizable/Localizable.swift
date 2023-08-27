import Foundation
import Combine

enum Localizable {
    
    // MARK: - Network Error
    @Localized static var networkErrorBadRequest = "networkErrorBadRequest"
    @Localized static var networkErrorUnauthorized = "networkErrorUnauthorized"
    @Localized static var networkErrorNotFound = "networkErrorNotFound"
    @Localized static var networkError500GenericMessage = "networkError500GenericMessage"
    @Localized static var networkError300GenericMessage = "networkError300GenericMessage"
    @Localized static var networkErrorUnknown = "networkErrorUnknown"
    
    // MARK: - App Error
    @Localized static var appErrorNoPathsAvailable = "appErrorNoPathsAvailable"
    @Localized static var appErrorOriginMissing = "appErrorOriginMissing"
    @Localized static var appErrorDestinationMissing = "appErrorDestinationMissing"
    @Localized static var appErrorPathMissing = "appErrorPathMissing"
    @Localized static var errorPleaseTryAgain = "errorPleaseTryAgain"
    
    // MARK: - Buttons
    @Localized static var buttonOk = "buttonOk"
    @Localized static var buttonSearch = "Search"
    
    //MARK: - Views
    @Localized static var mainViewTitle = "mainViewTitle"
    @Localized static var searchCityTextViewPlaceholder = "searchCityTextViewPlaceholder"
    
}

private extension Localizable {
    
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
}
