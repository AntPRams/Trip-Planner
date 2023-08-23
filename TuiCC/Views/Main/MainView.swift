//
//  ContentView.swift
//  TuiCC
//
//  Created by António Ramos on 22/08/2023.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Button("press me") {
                viewModel.fetchData()
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    MainView(viewModel: MainViewModel(networkProvider: ConnectionsService()))
}
