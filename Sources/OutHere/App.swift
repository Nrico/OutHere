import SwiftUI
import MapKit

@main
struct OutHereApp: App {
    @StateObject private var viewModel = SpotViewModel()
    @StateObject private var profile = UserProfile()
    @StateObject private var safety = SafetyViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(profile)
                .environmentObject(safety)
        }
    }
}
