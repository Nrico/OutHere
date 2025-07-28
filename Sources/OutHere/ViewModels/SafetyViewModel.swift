import SwiftUI

final class SafetyViewModel: ObservableObject {
    @AppStorage("safetySettings") private var stored: Data = Data()
    @Published var settings: UserSafetySettings = UserSafetySettings() {
        didSet { save() }
    }
    @Published var reportCounts: [UUID: Int] = [:]

    init() {
        if let decoded = try? JSONDecoder().decode(UserSafetySettings.self, from: stored) {
            settings = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(settings) {
            stored = data
        }
    }

    func block(_ id: UUID) {
        if !settings.blockedSpotIDs.contains(id) {
            settings.blockedSpotIDs.append(id)
        }
    }

    func mute(_ id: UUID) {
        if !settings.mutedSpotIDs.contains(id) {
            settings.mutedSpotIDs.append(id)
        }
    }

    func isBlocked(_ id: UUID) -> Bool {
        settings.blockedSpotIDs.contains(id)
    }

    func isMuted(_ id: UUID) -> Bool {
        settings.mutedSpotIDs.contains(id)
    }

    func addReport(for id: UUID) {
        reportCounts[id, default: 0] += 1
    }

    func isWithinSafeHours() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        for range in settings.safeHours {
            if range.lowerBound <= range.upperBound {
                if range.contains(hour) { return true }
            } else {
                if hour >= range.lowerBound || hour <= range.upperBound { return true }
            }
        }
        return false
    }
}
