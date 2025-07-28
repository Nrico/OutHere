import SwiftUI

struct ConnectionModalView: View {
    var context: ConnectionContext
    var dismiss: () -> Void
    @State private var sentNotice: String?
    @State private var glow = false

    private let reactions = ["👋","😊","🔥","🌈","👍","🎉"]

    var body: some View {
        VStack(spacing: 16) {
            Text("You and \(context.count) others like this spot right now.")
                .font(.headline)
            HStack {
                ForEach(context.sharedTags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(6)
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            if let sentNotice {
                Text(sentNotice)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Button("React") { sendReaction() }
                .buttonStyle(.borderedProminent)
            Button("Send a preset message") { sendMessage() }
                .buttonStyle(.bordered)
            Button("View shared tags") { }
                .buttonStyle(.bordered)
            Button("Request chat") {}
                .buttonStyle(.bordered)
                .disabled(true)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(.thinMaterial))
        .padding()
        .shadow(color: Color.accentColor.opacity(glow ? 0.6 : 0.0), radius: 20)
        .onAppear { withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) { glow.toggle() } }
    }

    private func sendReaction() {
        sentNotice = "Sent \(reactions.randomElement()!)"
        dismissAfter()
    }

    private func sendMessage() {
        sentNotice = "Message sent"
        dismissAfter()
    }

    private func dismissAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { dismiss() }
    }
}
