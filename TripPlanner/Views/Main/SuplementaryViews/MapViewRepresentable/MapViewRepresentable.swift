import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    
    let lineCoordinates: [CLLocationCoordinate2D]
    
    // MARK: - Build
    
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
