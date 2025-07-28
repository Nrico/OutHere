import Foundation

final class UserProfile: ObservableObject {
    @Published var nickname: String = "Friend"
    @Published var pronouns: String = "they/them"
    @Published var vibeEmoji: String = "🌈"
    @Published var interests: [String] = ["ally-owned", "quiet"]
    @Published var presenceMode: UserPresence = .anonymous
    @Published var followedSpots: Set<SpotLocation.ID> = []
}
