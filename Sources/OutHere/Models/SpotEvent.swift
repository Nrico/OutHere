import Foundation

struct SpotEvent: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let tags: [String]
    let locationName: String
    let spotID: UUID
}

extension SpotEvent {
    static let mockData: [SpotEvent] = [
        SpotEvent(
            id: UUID(),
            title: "Zine Swap Meetup",
            description: "Bring your latest creations and trade with others.",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            tags: ["zine swap", "art"],
            locationName: "Rainbow Cafe",
            spotID: SpotLocation.mockData[0].id
        ),
        SpotEvent(
            id: UUID(),
            title: "Sketch Jam",
            description: "Open sketch session in the park.",
            date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            tags: ["sketch jam", "outdoors"],
            locationName: "Open Park",
            spotID: SpotLocation.mockData[1].id
        ),
        SpotEvent(
            id: UUID(),
            title: "Poetry Reading",
            description: "Share your favorite poems or your own work.",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            tags: ["reading"],
            locationName: "Book Nook",
            spotID: SpotLocation.mockData[2].id
        ),
        SpotEvent(
            id: UUID(),
            title: "Game Night",
            description: "Tabletop games at the plaza square.",
            date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
            tags: ["game night"],
            locationName: "City Plaza",
            spotID: SpotLocation.mockData[3].id
        ),
        SpotEvent(
            id: UUID(),
            title: "Morning Coffee Hangout",
            description: "Casual meet and greet over coffee.",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            tags: ["coffee"],
            locationName: "Coffee Corner",
            spotID: SpotLocation.mockData[4].id
        )
    ]
}
