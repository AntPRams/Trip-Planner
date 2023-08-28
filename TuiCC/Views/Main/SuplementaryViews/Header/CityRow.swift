import SwiftUI

struct CityRow: View {
    
    var type: ConnectionType
    var text: String
    
    var body: some View {
        HStack {
            type.image
            Text(text)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
        )
        .padding(8)
    }
}
