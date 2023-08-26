import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                MainViewHeader(viewModel: viewModel)
                    .zIndex(1)
                Button("press me") {
                    viewModel.fetchData()
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Button("Lets test") {
                    let source = "Tokyo"
                    let destination = "Los Angeles"
                    viewModel.calculatePaths(from: source, to: destination)
                }
            }
            .padding()
            .navigationTitle("Search")
        }
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
