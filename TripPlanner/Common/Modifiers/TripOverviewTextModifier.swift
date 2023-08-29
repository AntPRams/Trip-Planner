import SwiftUI

struct TripOverviewTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, alignment: .center)
            .lineLimit(1)
    }
}
