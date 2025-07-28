import SwiftUI
import MapKit

final class SpotViewModel: ObservableObject {
    @Published var spots: [SpotLocation] = SpotLocation.mockData
    @Published var selectedSpot: SpotLocation?
    @Published var afternoonOnly: Bool = false

    // Presence count per spot id
    @Published private(set) var presenceCounts: [SpotLocation.ID: Int] = [:]

    var filteredSpots: [SpotLocation] {
        if afternoonOnly {
            return spots.filter { $0.tags.contains("afternoon") }
        }
        return spots
    }

    func activityLevel(for spot: SpotLocation) -> Int {
        let base = spot.activityLevel
        let additional = presenceCounts[spot.id, default: 0]
        return min(base + additional, 5)
    }

    func checkIn(at spot: SpotLocation, mode: UserPresence) {
        guard mode != .invisible else { return }
        presenceCounts[spot.id, default: 0] += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 600) { [weak self] in
            guard let self else { return }
            let current = self.presenceCounts[spot.id, default: 0]
            self.presenceCounts[spot.id] = max(current - 1, 0)
        }
    }
}
