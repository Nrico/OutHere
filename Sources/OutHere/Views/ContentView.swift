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
    @State private var showEvents = false
    @State private var showStandBy = false
    @State private var showSettings = false
    @State private var softNotice: String?

    var body: some View {
        NavigationContainer {
            ZStack(alignment: .top) {
                SpotMapView(spots: viewModel.filteredSpots, mode: mapMode, selectedSpot: $viewModel.selectedSpot)
                    .environmentObject(viewModel)
                    .environmentObject(profile)
                    .environmentObject(safety)
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
                .environmentObject(safety)
        }
        .sheet(isPresented: $showProfile) {
            NavigationContainer {
                ProfileView(editAction: { showOnboarding = true })
                    .environmentObject(profile)
                    .environmentObject(safety)
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
                .environmentObject(profile)
                .environmentObject(safety)
        }
        .sheet(isPresented: $showFollowed) {
            NavigationContainer { FollowedSpotsView() }
                .environmentObject(viewModel)
                .environmentObject(profile)
                .environmentObject(safety)
        }
        .sheet(isPresented: $showEvents) {
            NavigationContainer { EventBoardView() }
                .environmentObject(viewModel)
                .environmentObject(profile)
                .environmentObject(safety)
        }
        .fullScreenCover(isPresented: $showStandBy) {
            StandByView()
                .environmentObject(viewModel)
                .environmentObject(profile)
                .environmentObject(safety)
        }
        .sheet(isPresented: $showSettings) {
            NavigationContainer { SettingsView(viewModel: viewModel) }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showEvents = true }) {
                    Text("📅")
                }
            }
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Test StandBy View") { showStandBy = true }
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
