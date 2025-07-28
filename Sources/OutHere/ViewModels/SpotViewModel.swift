import SwiftUI
import MapKit

final class SpotViewModel: ObservableObject {
    @Published var spots: [SpotLocation] = SpotLocation.mockData
    @Published var events: [SpotEvent] = SpotEvent.mockData
    @Published var selectedSpot: SpotLocation?
    @Published var afternoonOnly: Bool = false

    // Presence count per spot id
    @Published private(set) var presenceCounts: [SpotLocation.ID: Int] = [:]
    @Published private(set) var mockUsers: [SpotLocation.ID: [MockUser]] = [:]
    @Published var activeSpots: Set<SpotLocation.ID> = []
    private var activityTimer: Timer?

    init() {
        generateMockUsers()
    }

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

    func startMockActivity(followed provider: @escaping () -> Set<SpotLocation.ID>) {
        activityTimer?.invalidate()
        activityTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.activateRandom(provider())
        }
    }

    private func activateRandom(_ followed: Set<SpotLocation.ID>) {
        guard !followed.isEmpty else { return }
        let ids = Array(followed).shuffled().prefix(2)
        for id in ids {
            activeSpots.insert(id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
                self?.activeSpots.remove(id)
            }
        }
    }

    func hasActiveFollowedSpots(_ followed: Set<SpotLocation.ID>) -> Bool {
        !activeSpots.intersection(followed).isEmpty
    }

    private func generateMockUsers() {
        let sampleTags = ["introvert", "extrovert", "gaming", "reading", "coffee", "outdoors"]
        for spot in spots {
            let count = Int.random(in: 0...3)
            var users: [MockUser] = []
            for _ in 0..<count {
                let tags = Array(sampleTags.shuffled().prefix(2))
                users.append(MockUser(tags: tags))
            }
            mockUsers[spot.id] = users
            presenceCounts[spot.id] = users.count
        }
    }

    func connectionContext(for spot: SpotLocation, profile: UserProfile) -> ConnectionContext? {
        let others = mockUsers[spot.id] ?? []
        guard others.count >= 2 else { return nil }
        let overlap = others.filter { !Set($0.tags).isDisjoint(with: profile.interests) }
        guard !overlap.isEmpty else { return nil }
        if Double.random(in: 0...1) > profile.connectionFrequency.chance { return nil }
        let shared = Array(Set(overlap.flatMap { $0.tags }).intersection(profile.interests))
        return ConnectionContext(count: others.count, sharedTags: shared)
    }
}
