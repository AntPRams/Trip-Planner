//
//  ContentView.swift
//  TuiCC
//
//  Created by António Ramos on 22/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
        .previewDisplayName("iPhone 14 Pro Max")
}
