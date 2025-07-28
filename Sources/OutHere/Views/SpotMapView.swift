import SwiftUI
import MapKit

enum MapDisplayMode: String, CaseIterable, Identifiable {
    case all, matched, followed
    var id: String { rawValue }
}

struct SpotMapView: View {
    var spots: [SpotLocation]
    var mode: MapDisplayMode = .all
    @Binding var selectedSpot: SpotLocation?
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    private func matches(_ spot: SpotLocation) -> Bool {
        !profile.interests.isEmpty && !Set(spot.tags).isDisjoint(with: profile.interests)
    }

    private var displayedSpots: [SpotLocation] {
        switch mode {
        case .all:
            return spots
        case .matched:
            return spots.filter(matches)
        case .followed:
            return spots.filter { profile.followedSpots.contains($0.id) }
        }
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: displayedSpots) { spot in
            MapAnnotation(coordinate: spot.coordinate) {
                SpotAnnotationView(
                    level: viewModel.activityLevel(for: spot),
                    dimmed: mode == .all && !matches(spot),
                    matched: matches(spot)
                )
                .onTapGesture {
                    selectedSpot = spot
                }
            }
        }
    }
}

#Preview {
    SpotMapView(spots: SpotLocation.mockData, mode: .all, selectedSpot: .constant(nil))
        .environmentObject(SpotViewModel())
        .environmentObject(UserProfile())
}
