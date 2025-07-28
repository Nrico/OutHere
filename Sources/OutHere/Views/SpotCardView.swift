import SwiftUI

struct SpotCardView: View {
    var spot: SpotLocation
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile
    @State private var toast: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(spot.name)
                    .font(.headline)
                Spacer()
                if viewModel.activeSpots.contains(spot.id) {
                    Text("Now active!")
                        .font(.caption2)
                        .padding(4)
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(6)
                }
            }
            HStack {
                ForEach(spot.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(4)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            HStack {
                Text("Activity: \(viewModel.activityLevel(for: spot))")
                    .font(.caption)
                Spacer()
                Button(profile.followedSpots.contains(spot.id) ? "Unfollow" : "Follow") {
                    toggleFollow()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .overlay(alignment: .top) {
            if let toast {
                Text(toast)
                    .font(.footnote)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .padding(4)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private func toggleFollow() {
        if profile.followedSpots.contains(spot.id) {
            profile.followedSpots.remove(spot.id)
            showToast("Unfollowed")
        } else {
            profile.followedSpots.insert(spot.id)
            showToast("Followed")
        }
    }

    private func showToast(_ text: String) {
        toast = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { toast = nil }
        }
    }
}

#Preview {
    SpotCardView(spot: .mockData.first!)
        .environmentObject(SpotViewModel())
        .environmentObject(UserProfile())
}
