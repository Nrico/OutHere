import SwiftUI

struct SpotAnnotationView: View {
    var level: Int
    var dimmed: Bool = false
    var matched: Bool = false
    @State private var animate = false

    private var size: CGFloat {
        CGFloat(20 + level * 10)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(dimmed ? 0.15 : 0.3))
                .frame(width: size, height: size)
                .blur(radius: size / 4)
            Circle()
                .stroke(Color.accentColor.opacity(dimmed ? 0.4 : 0.8), lineWidth: 2)
                .frame(width: size, height: size)
                .scaleEffect(animate ? (matched ? 1.4 : 1.2) : 0.8)
                .opacity(Double(level) / 5.0)
        }
        .onAppear { animate = true }
        .animation(
            .easeInOut(duration: Double(level))
                .repeatForever(autoreverses: true),
            value: animate
        )
    }
}

#Preview {
    SpotAnnotationView(level: 3)
}
