import Foundation
import MapKit

struct SpotLocation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let tags: [String]
    let activityLevel: Int // 1 (low) to 5 (high)
}

extension SpotLocation {
    static let mockData: [SpotLocation] = [
        SpotLocation(
            name: "Rainbow Cafe",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            tags: ["ally-owned", "quiet", "afternoon"],
            activityLevel: 4
        ),
        SpotLocation(
            name: "Open Park",
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
            tags: ["outdoors", "afternoon"],
            activityLevel: 3
        ),
        SpotLocation(
            name: "Book Nook",
            coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294),
            tags: ["quiet"],
            activityLevel: 2
        ),
        SpotLocation(
            name: "City Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4194),
            tags: ["evening"],
            activityLevel: 5
        ),
        SpotLocation(
            name: "Coffee Corner",
            coordinate: CLLocationCoordinate2D(latitude: 37.7699, longitude: -122.4094),
            tags: ["ally-owned", "morning"],
            activityLevel: 1
        )
    ]
}
