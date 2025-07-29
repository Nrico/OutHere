import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var profile: UserProfile
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationContainer {
            Form {
                Section {
                    Text("Please respect others and keep content safe for everyone.")
                        .font(.footnote)
                }
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
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } } }
        }
    }
}

#Preview {
    NavigationContainer { OnboardingView().environmentObject(UserProfile()) }
}

private extension OnboardingView {
    func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
