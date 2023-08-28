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
    @Localized static var appErrorPleaseTryAgain = "appErrorPleaseTryAgain"
    @Localized static var appErrorSameCityInBothFields = "appErrorSameCityInBothFields"
    
    // MARK: - Buttons
    @Localized static var buttonOk = "buttonOk"
    @Localized static var buttonSearch = "buttonSearch"
    @Localized static var buttonClear = "buttonClear"
    @Localized static var buttonRefresh = "buttonRefresh"
    
    //MARK: - Views
    @Localized static var mainViewTitle = "mainViewTitle"
    @Localized static var searchCityTextViewPlaceholder = "searchCityTextViewPlaceholder"
    @Localized static var bestDeal = "bestDeal"
    @Localized static var stopOvers = "stopOvers"
    
}
