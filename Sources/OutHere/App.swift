import SwiftUI
import MapKit

@main
struct OutHereApp: App {
    @StateObject private var viewModel = SpotViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
