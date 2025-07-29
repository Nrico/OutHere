import SwiftUI

/// A wrapper view that uses `NavigationStack` on modern OS versions and
/// falls back to `NavigationView` on older systems.
struct NavigationContainer<Content: View>: View {
    private let content: () -> Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            NavigationStack(root: content)
        } else {
            NavigationView { content() }
        }
    }
}
