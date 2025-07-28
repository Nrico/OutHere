import Foundation

enum DataMode: String, CaseIterable, Identifiable {
    case synthetic = "Test Data"
    case firebase = "Live Data (Firebase)"

    var id: String { self.rawValue }
}
