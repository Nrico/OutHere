import SwiftUI
import MapKit

struct SpotMapView: View {
    var spots: [SpotLocation]
    @Binding var selectedSpot: SpotLocation?

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: spots) { spot in
            MapAnnotation(coordinate: spot.coordinate) {
                SpotAnnotationView(level: spot.activityLevel)
                    .onTapGesture {
                        selectedSpot = spot
                    }
            }
        }
    }
}

#Preview {
    SpotMapView(spots: SpotLocation.mockData, selectedSpot: .constant(nil))
        .environmentObject(SpotViewModel())
}
