//
//  TripOverview.swift
//  TuiCC
//
//  Created by António Ramos on 28/08/2023.
//

import SwiftUI

struct TripOverview: View {
    
    var price: String
    var stopOvers: [[String?]]
    
    var body: some View {
        VStack {
            HStack {
                Text(Localizable.bestDeal)
                    .fontDesign(.rounded)
                    .font(.title.weight(.semibold))
                Spacer()
                Text(price)
                    .fontDesign(.rounded)
                    .font(.title2.weight(.semibold))
                    .padding(.horizontal)
            }
            HStack {
                Image.originPlaneImage
                    .frame(maxWidth: .infinity, alignment: .center)
                Image.destinationPlaneImage
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(2)
            Divider()
            ForEach(stopOvers, id: \.self) { stopOver in
                HStack {
                    if let origin = stopOver[0] {
                        Text(origin)
                            .modifier(TripOverviewTextModifier())
                    }
                    if let destination = stopOver[1] {
                        Text(destination)
                            .modifier(TripOverviewTextModifier())
                    }
                }
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.tripOverviewView)
        .padding(6)
        .modifier(BackgroundModifier())
    }
}

struct TripOverview_Previews: PreviewProvider {
    static var previews: some View {
        TripOverview(
            price: "3000",
            stopOvers:
                [
                    ["test", "test test"],
                    ["test test test test", "testtesttesttesttesttest testtesttesttesttest"]
                ]
        )
        .previewLayout(.sizeThatFits)
    }
}
