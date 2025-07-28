import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @State private var query: String = ""
    @State private var showFilters = false

    var body: some View {
        ZStack(alignment: .top) {
            SpotMapView(spots: viewModel.spots, selectedSpot: $viewModel.selectedSpot)
                .edgesIgnoringSafeArea(.all)

            HStack {
                SearchBar(text: $query)
                Button(action: { showFilters.toggle() }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.selectedSpot) { spot in
            SpotDetailCard(spot: spot)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SpotViewModel())
}
