import Foundation
import SwiftUI

final class UserProfile: ObservableObject {
    @Published var nickname: String = "Friend"
    @Published var pronouns: String = "they/them"
    @Published var vibeEmoji: String = "🌈"
    @Published var interests: [String] = ["ally-owned", "quiet"]
    @Published var presenceMode: UserPresence = .anonymous
    @AppStorage("followedSpots") private var storedFollowed: Data = Data()
    @Published var followedSpots: Set<SpotLocation.ID> = [] {
        didSet { saveFollowed() }
    }

    init() {
        if let ids = try? JSONDecoder().decode([UUID].self, from: storedFollowed) {
            followedSpots = Set(ids)
        }
    }

    private func saveFollowed() {
        if let data = try? JSONEncoder().encode(Array(followedSpots)) {
            storedFollowed = data
        }
    }
}
