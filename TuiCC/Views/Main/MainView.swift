import SwiftUI
import CoreLocationUI
import MapKit

struct MainView<ViewModel: MainViewModelInterface>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if case .loading = viewModel.currentState {
                ProgressView()
            }
            VStack {
                MainViewHeader(viewModel: viewModel)
                    .padding(6)
                    .zIndex(1)
                Divider()
                Text("Flight")
                Text("Price")
                if let coordinates = viewModel.coordinates {
                    MapViewRepresentable(lineCoordinates: coordinates)
                        .cornerRadius(10)
                        .padding()
                }
                Spacer()
            }
            .allowsHitTesting(viewModel.currentState != .loading)
            .navigationTitle(Localizable.mainViewTitle)
            .errorAlert(error: $viewModel.error)
        }
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(networkProvider: ConnectionsService()))
    }
}
