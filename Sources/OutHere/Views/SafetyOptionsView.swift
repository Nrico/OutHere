import SwiftUI

struct SafetyOptionsView: View {
    var id: UUID
    var name: String
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showReport = false
    @State private var showSafeHours = false

    var body: some View {
        NavigationStack {
            List {
                Button("Report this \(name)") { showReport = true }
                Button("Block this spot") {
                    safety.block(id)
                    dismiss()
                }
                Button("Mute for 30 days") {
                    safety.mute(id)
                    dismiss()
                }
                Button("Set my safe hours") { showSafeHours = true }
            }
            .navigationTitle("Safety Options")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } }
            }
            .sheet(isPresented: $showReport) {
                ReportContentView(contentID: id, done: { dismiss() })
                    .environmentObject(safety)
            }
            .sheet(isPresented: $showSafeHours) {
                SafeHoursView()
                    .environmentObject(safety)
            }
        }
    }
}

struct SafeHoursView: View {
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var startHour: Int = 22
    @State private var endHour: Int = 6

    var body: some View {
        NavigationStack {
            Form {
                Picker("Start", selection: $startHour) {
                    ForEach(0..<24) { Text("\($0):00").tag($0) }
                }
                Picker("End", selection: $endHour) {
                    ForEach(0..<24) { Text("\($0):00").tag($0) }
                }
                Button("Add Range") {
                    safety.settings.safeHours.append(startHour...endHour)
                    dismiss()
                }
            }
            .navigationTitle("Safe Hours")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } }
            }
        }
    }
}

struct ReportContentView: View {
    var contentID: UUID
    var done: () -> Void
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var reason: String = "Inappropriate content"
    @State private var details: String = ""
    private let reasons = ["Inappropriate content", "Hate speech", "Unsafe place", "Other"]
    @State private var showThanks = false

    var body: some View {
        NavigationStack {
            Form {
                Picker("Reason", selection: $reason) {
                    ForEach(reasons, id: \.self) { Text($0) }
                }
                TextField("Details", text: $details)
                Button("Submit") {
                    print("Report for \(contentID): \(reason) - \(details)")
                    safety.addReport(for: contentID)
                    showThanks = true
                }
            }
            .navigationTitle("Report Content")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } }
            }
            .alert("Thanks for helping keep the community safe. Respect others!", isPresented: $showThanks) {
                Button("OK") {
                    done()
                    dismiss()
                }
            }
        }
    }
}

