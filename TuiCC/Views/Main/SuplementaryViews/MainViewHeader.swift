import SwiftUI


struct MainViewHeader<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState private var focusedField: ConnectionType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SearchField(viewModel: viewModel.originSearchFieldViewModel)
                .focused($focusedField, equals: .origin)
                .zIndex(3)
            SearchField(viewModel: viewModel.destinationSearchFieldViewModel)
                .focused($focusedField, equals: .destination)
                .zIndex(2)
            HStack {
                Spacer()
                Button {
                    viewModel.calculatePaths()
                } label: {
                    Text(Localizable.buttonSearch)
                }
                Spacer()
            }
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

enum ConnectionType {
    case origin
    case destination
}

struct MainViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainViewHeader(viewModel: MainViewModel())
            .previewLayout(.sizeThatFits)
    }
}
