import SwiftUI

struct SpotAnnotationView: View {
    var activity: Double

    var body: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.4))
            .frame(width: 40, height: 40)
            .overlay(
                Circle()
                    .stroke(Color.accentColor, lineWidth: 2)
                    .blur(radius: 4)
                    .opacity(activity)
            )
    }
}

#Preview {
    SpotAnnotationView(activity: 1.0)
}
