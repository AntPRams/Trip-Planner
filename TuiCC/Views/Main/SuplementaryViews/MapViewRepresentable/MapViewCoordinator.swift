import MapKit
import SwiftUI

class Coordinator: NSObject {
    
    // MARK: - Properties
    
    var parent: MapViewRepresentable
    
    // MARK: - Init
    
    init(_ parent: MapViewRepresentable) {
        self.parent = parent
    }
}

// MARK: - MKMapViewDelegate

extension Coordinator: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
