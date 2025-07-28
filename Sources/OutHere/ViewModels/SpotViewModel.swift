import SwiftUI
import MapKit
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

final class SpotViewModel: ObservableObject {
    @Published var spots: [SpotLocation] = []
    @Published var events: [SpotEvent] = SpotEvent.mockData
    @Published var selectedSpot: SpotLocation?
    @Published var afternoonOnly: Bool = false

    @AppStorage("dataMode") private var dataModeRaw: String = DataMode.synthetic.rawValue
    @Published var dataMode: DataMode = .synthetic {
        didSet {
            dataModeRaw = dataMode.rawValue
            loadSpots()
            loadEvents()
        }
    }

    // Presence count per spot id
    @Published private(set) var presenceCounts: [SpotLocation.ID: Int] = [:]
    @Published private(set) var mockUsers: [SpotLocation.ID: [MockUser]] = [:]
    #if canImport(FirebaseFirestore)
    private var presenceListeners: [SpotLocation.ID: ListenerRegistration] = [:]
    private var spotsListener: ListenerRegistration?
    #endif
    @Published var activeSpots: Set<SpotLocation.ID> = []
    private var activityTimer: Timer?

    init() {
        self.dataMode = DataMode(rawValue: dataModeRaw) ?? .synthetic
        loadSpots()
        loadEvents()
    }

    var filteredSpots: [SpotLocation] {
        if afternoonOnly {
            return spots.filter { $0.tags.contains("afternoon") }
        }
        return spots
    }

    func activityLevel(for spot: SpotLocation) -> Int {
        let base = spot.popularityLevel
        let additional = presenceCounts[spot.id, default: 0]
        return min(base + additional, 5)
    }

    func checkIn(at spot: SpotLocation, mode: UserPresence, safety: SafetyViewModel? = nil, profile: UserProfile? = nil) {
        guard mode != .invisible else { return }
        if safety?.isWithinSafeHours() == true { return }
        FirebaseService.shared.checkIn(userID: FirebaseService.shared.userID, spotID: spot.id.uuidString, mode: mode)
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

    func loadSpots() {
        if dataMode == .synthetic {
#if canImport(FirebaseFirestore)
            spotsListener?.remove()
            spotsListener = nil
            for listener in presenceListeners.values { listener.remove() }
            presenceListeners.removeAll()
#endif
            spots = SpotLocation.mockData
            generateMockUsers()
        } else {
            fetchSpotsFromFirebase()
        }
    }

    func loadEvents() {
        if dataMode == .synthetic {
            events = SpotEvent.mockData
        } else {
            fetchEventsFromFirebase()
        }
    }

    private func fetchSpotsFromFirebase() {
#if canImport(FirebaseFirestore)
        spotsListener?.remove()
        spotsListener = FirebaseService.shared.observeSpots { [weak self] spots in
            self?.spots = spots
            self?.listenForPresence(spots)
        }
#endif
    }

    private func fetchEventsFromFirebase() {
#if canImport(FirebaseFirestore)
        // TODO: Implement real fetch when backend available
#endif
        events = SpotEvent.mockData
    }

#if canImport(FirebaseFirestore)
    private func listenForPresence(_ spots: [SpotLocation]) {
        // remove existing listeners
        for listener in presenceListeners.values { listener.remove() }
        presenceListeners.removeAll()
        for spot in spots {
            let registration = FirebaseService.shared.observePresence(for: spot.id.uuidString) { [weak self] count in
                self?.presenceCounts[spot.id] = count
            }
            presenceListeners[spot.id] = registration
        }
    }
#endif

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
