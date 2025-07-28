import SwiftUI

struct SpotDetailCard: View {
    var spot: Spot

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            Text(spot.name)
                .font(.title2)
                .bold()

            Text(spot.description)
                .font(.body)

            HStack {
                ForEach(spot.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(6)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            HStack {
                Button("I’m here now") {}
                    .buttonStyle(.borderedProminent)
                Button("Follow") {}
                    .buttonStyle(.bordered)
                Button("Wave") {}
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    SpotDetailCard(spot: .mockData.first!)
}
