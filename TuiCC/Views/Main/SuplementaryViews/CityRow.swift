import SwiftUI

struct CityRow: View {
    
    var type: ConnectionType
    var text: String
    
    var body: some View {
        HStack {
            type == .origin ?
            Image.originPlaneImage :
            Image.destinationPlaneImage
            Text(text)
            Spacer()
        }
        .padding(8)
    }
}
