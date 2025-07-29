import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    var editAction: (() -> Void)? = nil
    @State private var showSafety = false

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

                Button("Safety Options") { showSafety = true }
                    .buttonStyle(.bordered)

                Text("Interests")
                    .font(.headline)
                interestTags

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } } }
        .sheet(isPresented: $showSafety) {
            SafetyOptionsView(id: UUID(), name: "profile")
                .environmentObject(safety)
        }
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
    NavigationContainer { ProfileView() }
        .environmentObject(UserProfile())
}

private extension ProfileView {
    func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
