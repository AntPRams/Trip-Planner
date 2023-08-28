import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    let lineCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .satelliteFlyover
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)

        return mapView
      }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let overlays = view.overlays
        view.removeOverlays(overlays)
        
        if let origin = lineCoordinates.first {
            let span = MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
            view.setRegion(MKCoordinateRegion(center: origin, span: span), animated: true)
        }
        
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        view.addOverlay(polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewRepresentable
    
    init(_ parent: MapViewRepresentable) {
        self.parent = parent
    }
    
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

