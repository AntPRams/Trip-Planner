import SwiftUI
import CoreLocationUI
import MapKit

struct MainView<ViewModel: MainViewModelInterface>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                MainViewHeader(viewModel: viewModel)
                    .padding(6)
                    .zIndex(1)
                Divider()
                    .background(Color.clear)
                if case .loading = viewModel.currentState {
                    ProgressView()
                }
                ScrollView {
                    if let path = viewModel.pathResult {
                        TripOverview(
                            price: path.price,
                            stopOvers: path.stopOvers
                        )
                        MapViewRepresentable(lineCoordinates: path.coordinates)
                            .cornerRadius(10)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollBounceBehavior(.always)
                .padding(.horizontal)
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
