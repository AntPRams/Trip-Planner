import Foundation

enum AppConstants: String {
    
    // MARK: - Network Error
    case networkErrorBadRequest
    case networkErrorUnauthorized
    case networkErrorNotFound
    case networkError500GenericMessage
    case networkError300GenericMessage
    case networkErrorUnknown
    
    static func localized(_ constant: AppConstants) -> String {
        NSLocalizedString(constant.rawValue, comment: "")
    }
}