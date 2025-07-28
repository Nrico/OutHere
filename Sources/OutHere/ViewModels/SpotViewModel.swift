import SwiftUI
import MapKit

final class SpotViewModel: ObservableObject {
    @Published var spots: [SpotLocation] = SpotLocation.mockData
    @Published var selectedSpot: SpotLocation?
    @Published var afternoonOnly: Bool = false

    var filteredSpots: [SpotLocation] {
        if afternoonOnly {
            return spots.filter { $0.tags.contains("afternoon") }
        }
        return spots
    }
}
