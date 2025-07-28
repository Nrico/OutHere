import Foundation

struct MockUser: Identifiable {
    let id = UUID()
    let tags: [String]
}

struct ConnectionContext: Identifiable {
    let id = UUID()
    let count: Int
    let sharedTags: [String]
}
