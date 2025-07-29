import SwiftUI

struct EventBoardView: View {
    @EnvironmentObject var viewModel: SpotViewModel
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss

    @State private var interested: Set<SpotEvent.ID> = []
    @State private var onlyFollowed = false

    private var displayedEvents: [SpotEvent] {
        var list = viewModel.events.filter { event in
            // match user interests
            profile.interests.isEmpty || !Set(event.tags).isDisjoint(with: profile.interests)
        }
        if onlyFollowed {
            list = list.filter { profile.followedSpots.contains($0.spotID) }
        }
        list = list.filter { !safety.isBlocked($0.spotID) && !safety.isBlocked($0.id) }
        return list.sorted { $0.date < $1.date }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Toggle("Only events at spots I follow", isOn: $onlyFollowed)
                    .padding([.horizontal, .top])
                ForEach(displayedEvents) { event in
                    EventCardView(event: event, interested: $interested)
                        .environmentObject(safety)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Events")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } } }
    }

    private func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EventCardView: View {
    var event: SpotEvent
    @Binding var interested: Set<SpotEvent.ID>
    var showButton: Bool = true
    @EnvironmentObject var safety: SafetyViewModel
    @State private var showSafety = false

    private var isInterested: Bool { interested.contains(event.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(.headline)
            Text(event.date, style: .date)
                .font(.subheadline)
            Text(event.date, style: .time)
                .font(.subheadline)
            Text(event.locationName)
                .font(.subheadline)
            HStack {
                ForEach(event.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(4)
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(4)
                }
            }
            if showButton {
                Button(isInterested ? "Interested" : "I'm Interested") {
                    if isInterested {
                        interested.remove(event.id)
                    } else {
                        interested.insert(event.id)
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Safety Options") { showSafety = true }
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .opacity(safety.isMuted(event.id) ? 0.5 : 1)
        .sheet(isPresented: $showSafety) {
            SafetyOptionsView(id: event.id, name: "event")
                .environmentObject(safety)
        }
    }
}

struct SpotEventDetailView: View {
    var event: SpotEvent
    @State private var interested = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(event.title)
                    .font(.title2)
                    .bold()
                Text(event.date, style: .date)
                Text(event.date, style: .time)
                Text("Location: \(event.locationName)")
                HStack {
                    ForEach(event.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(4)
                            .background(Color.accentColor.opacity(0.15))
                            .cornerRadius(4)
                    }
                }
                Text(event.description)
                Button(interested ? "Interested" : "I'm Interested") { interested.toggle() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationContainer {
        EventBoardView()
            .environmentObject(SpotViewModel())
            .environmentObject(UserProfile())
    }
}
