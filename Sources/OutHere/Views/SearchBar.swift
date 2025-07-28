import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search", text: $text)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 8)
                        .foregroundColor(.secondary)
                }
            )
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .padding()
        .background(Color.gray)
}
