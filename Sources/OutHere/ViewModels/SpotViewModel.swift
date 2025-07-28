import SwiftUI
import MapKit

final class SpotViewModel: ObservableObject {
    @Published var spots: [Spot] = Spot.mockData
    @Published var selectedSpot: Spot?
}
