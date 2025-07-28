import Foundation

enum UserPresence: String, CaseIterable, Identifiable {
    case visible
    case anonymous
    case invisible

    var id: String { rawValue }
}
