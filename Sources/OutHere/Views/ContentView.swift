import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile
    @State private var query: String = ""
    @State private var showFilters = false
    @State private var mapMode: MapDisplayMode = .all
    @State private var showProfile = false
    @State private var showOnboarding = false
    @State private var showFollowed = false
    @State private var softNotice: String?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                SpotMapView(spots: viewModel.filteredSpots, mode: mapMode, selectedSpot: $viewModel.selectedSpot)
                    .environmentObject(viewModel)
                    .environmentObject(profile)
                    .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    SearchBar(text: $query)
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                    Spacer()
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
                .padding()

                Picker("Mode", selection: $mapMode) {
                    ForEach(MapDisplayMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Spacer()

                Toggle("Afternoon Only", isOn: $viewModel.afternoonOnly)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding()
            }
            .overlay(alignment: .top) {
                if let softNotice {
                    Text(softNotice)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .sheet(item: $viewModel.selectedSpot) { spot in
            SpotDetailCard(spot: spot, presenceMode: $profile.presenceMode)
                .environmentObject(profile)
        }
        .sheet(isPresented: $showProfile) {
            NavigationStack {
                ProfileView(editAction: { showOnboarding = true })
                    .environmentObject(profile)
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
                .environmentObject(profile)
        }
        .sheet(isPresented: $showFollowed) {
            NavigationStack { FollowedSpotsView() }
                .environmentObject(viewModel)
                .environmentObject(profile)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showFollowed = true }) {
                    Image(systemName: "bell")
                }
                .overlay(alignment: .topTrailing) {
                    if viewModel.hasActiveFollowedSpots(profile.followedSpots) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .onAppear {
            simulateActivityNotification()
            viewModel.startMockActivity(followed: { profile.followedSpots })
        }
    }

    private func simulateActivityNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard let spot = viewModel.spots.first(where: { !Set($0.tags).isDisjoint(with: profile.interests) }) else { return }
            withAnimation {
                softNotice = "\(spot.name) is active!"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { softNotice = nil }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SpotViewModel())
        .environmentObject(UserProfile())
}
