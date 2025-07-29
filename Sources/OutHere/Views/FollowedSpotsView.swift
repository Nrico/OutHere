import SwiftUI

struct FollowedSpotsView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) private var presentationMode
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
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } } }
    }
}

#Preview {
    NavigationContainer {
        FollowedSpotsView()
            .environmentObject(SpotViewModel())
            .environmentObject(UserProfile())
    }
}

private extension FollowedSpotsView {
    func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
