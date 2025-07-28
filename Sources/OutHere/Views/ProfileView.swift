import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    var editAction: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(profile.vibeEmoji)
                        .font(.system(size: 48))
                    VStack(alignment: .leading) {
                        Text(profile.nickname)
                            .font(.title)
                            .bold()
                        Text(profile.pronouns)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("Edit") {
                        editAction?()
                    }
                }
                presenceToggle
                connectionFrequencyPicker

                Text("Interests")
                    .font(.headline)
                interestTags

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
    }

    private var interestTags: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)]) {
            ForEach(profile.interests, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(8)
            }
        }
    }

    private var presenceToggle: some View {
        Picker("Presence Mode", selection: $profile.presenceMode) {
            ForEach(UserPresence.allCases) { mode in
                Text(mode.rawValue.capitalized).tag(mode)
            }
        }
        .pickerStyle(.segmented)
    }

    private var connectionFrequencyPicker: some View {
        Picker("Connection Notices", selection: $profile.connectionFrequency) {
            ForEach(ConnectionFrequency.allCases) { freq in
                Text(freq.rawValue.capitalized).tag(freq)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environmentObject(UserProfile())
}
