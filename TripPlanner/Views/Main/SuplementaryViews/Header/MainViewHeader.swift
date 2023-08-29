import SwiftUI


struct MainViewHeader<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: ConnectionType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SearchField(viewModel: viewModel.originSearchFieldViewModel)
                .focused($focusedField, equals: .origin)
                .zIndex(3)
                .accessibilityIdentifier(AccessibilityIdentifiers.originSearchField)
            SearchField(viewModel: viewModel.destinationSearchFieldViewModel)
                .focused($focusedField, equals: .destination)
                .zIndex(2)
                .accessibilityIdentifier(AccessibilityIdentifiers.destinationSearchField)
            ButtonsRow(
                viewModel: viewModel,
                focusedField: _focusedField
            )
        }
        .padding(6)
        .onSubmit {
            switch focusedField {
            case .origin:
                focusedField = .destination
            case .destination:
                focusedField = nil
            case .none:
                break
            }
        }
    }
}

struct MainViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainViewHeader(viewModel: MainViewModel())
            .previewLayout(.sizeThatFits)
    }
}
