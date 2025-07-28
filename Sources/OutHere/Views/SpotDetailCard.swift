import SwiftUI

struct SpotDetailCard: View {
    var spot: SpotLocation
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile

    @Binding var presenceMode: UserPresence
    @State private var toastMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Presence", selection: $presenceMode) {
                ForEach(UserPresence.allCases) { mode in
                    Text(mode.rawValue.capitalized).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Text(spot.name)
                .font(.title2)
                .bold()

            HStack {
                ForEach(spot.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(6)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            HStack {
                Button("I’m here now") {
                    checkInTapped()
                }
                .buttonStyle(.borderedProminent)
                Button(profile.followedSpots.contains(spot.id) ? "Unfollow" : "Follow") {
                    toggleFollow()
                }
                .buttonStyle(.bordered)
                Button("Wave") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .padding()
        .overlay(alignment: .top) {
            if let toastMessage {
                Text(toastMessage)
                    .font(.footnote)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private func checkInTapped() {
        if presenceMode == .invisible {
            showToast("Switch to visible or anonymous to check in")
            return
        }

        viewModel.checkIn(at: spot, mode: presenceMode)

        switch presenceMode {
        case .visible:
            showToast("You’ve checked in visibly at \(spot.name)")
        case .anonymous:
            showToast("You’ve checked in anonymously")
        case .invisible:
            break
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                toastMessage = nil
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
}

#Preview {
    SpotDetailCard(spot: .mockData.first!, presenceMode: .constant(.anonymous))
        .environmentObject(SpotViewModel())
        .environmentObject(UserProfile())
}
