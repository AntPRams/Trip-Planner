//
//  ContentView.swift
//  TuiCC
//
//  Created by António Ramos on 22/08/2023.
//

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
            }
            .padding()
            .navigationTitle("Search")
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
//
//#Preview {
//    MainView(viewModel: MainViewModel(networkProvider: ConnectionsService()))
//}
