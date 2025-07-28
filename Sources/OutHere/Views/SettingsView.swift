import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SpotViewModel

    var body: some View {
        Form {
            Picker("Data Mode", selection: $viewModel.dataMode) {
                ForEach(DataMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(viewModel: SpotViewModel())
}
