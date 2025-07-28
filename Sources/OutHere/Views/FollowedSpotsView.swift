import SwiftUI

struct FollowedSpotsView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile
    @Environment(\.dismiss) private var dismiss

    private var followed: [SpotLocation] {
        viewModel.spots.filter { profile.followedSpots.contains($0.id) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(followed) { spot in
                    SpotCardView(spot: spot)
                }
            }
            .padding()
        }
        .navigationTitle("Followed Spots")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
    }
}

#Preview {
    NavigationStack {
        FollowedSpotsView()
            .environmentObject(SpotViewModel())
            .environmentObject(UserProfile())
    }
}
