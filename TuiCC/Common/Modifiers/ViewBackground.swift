import SwiftUI

struct ViewBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .shadow(color: .secondary, radius: 1)
            )
    }
}
