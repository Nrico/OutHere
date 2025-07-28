import SwiftUI

struct StandByView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile

    @State private var currentIndex: Int = 0

    private var followedSpots: [SpotLocation] {
        viewModel.spots.filter { profile.followedSpots.contains($0.id) }
            .sorted { viewModel.activityLevel(for: $0) > viewModel.activityLevel(for: $1) }
    }

    private var displayedSpots: [SpotLocation] {
        Array(followedSpots.prefix(3))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(.darkGray)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if displayedSpots.isEmpty {
                Text("No followed spots")
                    .foregroundColor(.white)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(Array(displayedSpots.enumerated()), id: \.offset) { index, spot in
                        StandBySpotCard(spot: spot)
                            .environmentObject(viewModel)
                            .tag(index)
                            .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 1), value: currentIndex)
            }
            VStack {
                Spacer()
                Text("You're not alone — people are out here too.")
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .onAppear(perform: startTimer)
    }

    private func startTimer() {
        guard displayedSpots.count > 1 else { return }
        Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { _ in
            currentIndex = (currentIndex + 1) % displayedSpots.count
        }
    }
}

struct StandBySpotCard: View {
    var spot: SpotLocation
    @EnvironmentObject var viewModel: SpotViewModel

    @State private var pulse = false

    private var activityLevel: Int { viewModel.activityLevel(for: spot) }

    private var tagline: String {
        spot.tags.first ?? "Quiet spot"
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(spot.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Text(tagline)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
            activityDots
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.4))
                .shadow(color: Color.accentColor.opacity(pulse ? 0.6 : 0.0), radius: 20)
        )
        .scaleEffect(pulse && viewModel.activeSpots.contains(spot.id) ? 1.05 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var activityDots: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { i in
                Circle()
                    .fill(i <= activityLevel ? Color.accentColor : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
            }
        }
    }
}

#Preview {
    StandByView()
        .environmentObject(SpotViewModel())
        .environmentObject(UserProfile())
}
