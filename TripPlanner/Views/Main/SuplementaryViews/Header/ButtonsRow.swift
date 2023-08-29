import SwiftUI

struct ButtonsRow<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState var focusedField: ConnectionType?
    
    var body: some View {
        HStack {
            Spacer()
            AppButton(
                image: .magnifyingGlass,
                text: Text(Localizable.buttonSearch)
            ) {
                focusedField = nil
                viewModel.calculatePaths()
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.searchButton)
            AppButton(
                image: .clear,
                text: Text(Localizable.buttonClear),
                color: .secondary
            ) {
                viewModel.clear()
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.clearButton)
            AppButton(
                image: .refresh,
                text: Text(Localizable.buttonRefresh)
            ) {
                viewModel.fetchData()
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.refreshButton)
            Spacer()
        }
    }
}

struct ButtonsRow_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsRow(viewModel: MainViewModel())
    }
}
