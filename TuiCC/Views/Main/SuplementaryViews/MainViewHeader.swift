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
                    Text("Search")
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

extension View {
    
    
}

enum ConnectionType {
    case origin
    case destination
}

struct CityRow: View {
    
    var type: ConnectionType
    var text: String
    
    var body: some View {
        HStack {
            type == .origin ?
            Image.originPlaneImage :
            Image.destinationPlaneImage
            Text(text)
            Spacer()
        }
        .frame(height: 20)
    }
}

struct MainViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        MainViewHeader(viewModel: MainViewModel())
            .previewLayout(.sizeThatFits)
    }
}
