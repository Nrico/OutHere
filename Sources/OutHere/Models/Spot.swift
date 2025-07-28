import Foundation
import MapKit

struct Spot: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let tags: [String]
    let coordinate: CLLocationCoordinate2D
    let activity: Double
}

extension Spot {
    static let mockData: [Spot] = [
        Spot(
            name: "Rainbow Cafe",
            description: "Cozy spot with friendly staff.",
            tags: ["ally-owned", "quiet"],
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            activity: 0.8
        ),
        Spot(
            name: "Open Park",
            description: "Wide open spaces for gatherings.",
            tags: ["outdoors"],
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
            activity: 0.6
        ),
        Spot(
            name: "Book Nook",
            description: "LGBTQ+ friendly bookstore.",
            tags: ["quiet", "ally-owned"],
            coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294),
            activity: 0.4
        )
    ]
}
