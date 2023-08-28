//
//  TripOverview.swift
//  TuiCC
//
//  Created by António Ramos on 28/08/2023.
//

import SwiftUI

struct TripOverview: View {
    
    @Currency var price: String
    var stopOvers: [[String?]]
    
    var body: some View {
        VStack {
            HStack {
                Text(Localizable.bestDeal)
                    .fontDesign(.rounded)
                    .font(.title.weight(.semibold))
                Spacer()
                Text(price)
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
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    if let destination = stopOver[1] {
                        Text(destination)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .padding(6)
        .modifier(ViewBackground())
    }
}

struct TripOverview_Previews: PreviewProvider {
    static var previews: some View {
        TripOverview(price: "3000", stopOvers: [["adasdasdsaa", "qweqeqeqwe"], ["qweqqe eqweq", "sadsdada"]])
            .previewLayout(.sizeThatFits)
    }
}
