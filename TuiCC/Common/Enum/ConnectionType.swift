import SwiftUI

enum ConnectionType {
    case origin
    case destination
    
    var image: Image {
        switch self {
        case .origin:
            return Image.originPlaneImage
        case .destination:
            return Image.destinationPlaneImage
        }
    }
}
