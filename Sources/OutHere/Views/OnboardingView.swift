import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basics")) {
                    TextField("Nickname", text: $profile.nickname)
                    TextField("Pronouns", text: $profile.pronouns)
                    TextField("Vibe Emoji", text: $profile.vibeEmoji)
                }
                Section(header: Text("Interests")) {
                    TextField("Comma separated", text: Binding(
                        get: { profile.interests.joined(separator: ", ") },
                        set: { profile.interests = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                    ))
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

#Preview {
    OnboardingView().environmentObject(UserProfile())
}
