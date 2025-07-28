import SwiftUI

struct SpotAnnotationView: View {
    var level: Int
    @State private var animate = false

    private var size: CGFloat {
        CGFloat(20 + level * 10)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.3))
                .frame(width: size, height: size)
                .blur(radius: size / 4)
            Circle()
                .stroke(Color.accentColor.opacity(0.8), lineWidth: 2)
                .frame(width: size, height: size)
                .scaleEffect(animate ? 1.2 : 0.8)
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
