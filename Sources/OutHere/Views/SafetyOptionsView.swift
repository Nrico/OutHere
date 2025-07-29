import SwiftUI

struct SafetyOptionsView: View {
    var id: UUID
    var name: String
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showReport = false
    @State private var showSafeHours = false

    var body: some View {
        NavigationContainer {
            List {
                Button("Report this \(name)") { showReport = true }
                Button("Block this spot") {
                    safety.block(id)
                    close()
                }
                Button("Mute for 30 days") {
                    safety.mute(id)
                    close()
                }
                Button("Set my safe hours") { showSafeHours = true }
            }
            .navigationTitle("Safety Options")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } }
            }
            .sheet(isPresented: $showReport) {
                ReportContentView(contentID: id, done: { close() })
                    .environmentObject(safety)
            }
            .sheet(isPresented: $showSafeHours) {
                SafeHoursView()
                    .environmentObject(safety)
            }
        }
    }

    private func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SafeHoursView: View {
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var startHour: Int = 22
    @State private var endHour: Int = 6

    var body: some View {
        NavigationContainer {
            Form {
                Picker("Start", selection: $startHour) {
                    ForEach(0..<24) { Text("\($0):00").tag($0) }
                }
                Picker("End", selection: $endHour) {
                    ForEach(0..<24) { Text("\($0):00").tag($0) }
                }
                Button("Add Range") {
                    safety.settings.safeHours.append(startHour...endHour)
                    close()
                }
            }
            .navigationTitle("Safe Hours")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } }
            }
        }
    }

    private func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ReportContentView: View {
    var contentID: UUID
    var done: () -> Void
    @EnvironmentObject var safety: SafetyViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var reason: String = "Inappropriate content"
    @State private var details: String = ""
    private let reasons = ["Inappropriate content", "Hate speech", "Unsafe place", "Other"]
    @State private var showThanks = false

    var body: some View {
        NavigationContainer {
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
                ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { close() } }
            }
            .alert("Thanks for helping keep the community safe. Respect others!", isPresented: $showThanks) {
                Button("OK") {
                    done()
                    close()
                }
            }
        }
    }

    private func close() {
        if #available(iOS 15.0, macOS 12.0, *) {
            dismiss()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

