import Foundation
import MapKit

struct SpotLocation: Identifiable, Hashable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    let tags: [String]
    let popularityLevel: Int // 1 (low) to 5 (high)

    init(id: UUID = UUID(), name: String, coordinate: CLLocationCoordinate2D, tags: [String], popularityLevel: Int) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.tags = tags
        self.popularityLevel = popularityLevel
    }
}

extension SpotLocation {
    static let mockData: [SpotLocation] = [
        SpotLocation(
            name: "Rainbow Cafe",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            tags: ["ally-owned", "quiet", "afternoon"],
            popularityLevel: 4
        ),
        SpotLocation(
            name: "Open Park",
            coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
            tags: ["outdoors", "afternoon"],
            popularityLevel: 3
        ),
        SpotLocation(
            name: "Book Nook",
            coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294),
            tags: ["quiet"],
            popularityLevel: 2
        ),
        SpotLocation(
            name: "City Plaza",
            coordinate: CLLocationCoordinate2D(latitude: 37.7799, longitude: -122.4194),
            tags: ["evening"],
            popularityLevel: 5
        ),
        SpotLocation(
            name: "Coffee Corner",
            coordinate: CLLocationCoordinate2D(latitude: 37.7699, longitude: -122.4094),
            tags: ["ally-owned", "morning"],
            popularityLevel: 1
        )
    ]
}

#if canImport(FirebaseFirestore)
import FirebaseFirestore

extension SpotLocation {
    init?(from document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let name = data["name"] as? String,
            let tags = data["tags"] as? [String],
            let level = data["popularityLevel"] as? Int,
            let lat = data["latitude"] as? Double,
            let lng = data["longitude"] as? Double
        else { return nil }

        self.id = UUID(uuidString: document.documentID) ?? UUID()
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.tags = tags
        self.popularityLevel = level
    }
}
#endif
