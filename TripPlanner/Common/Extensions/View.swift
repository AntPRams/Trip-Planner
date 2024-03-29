import SwiftUI

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = Localizable.buttonOk) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}
