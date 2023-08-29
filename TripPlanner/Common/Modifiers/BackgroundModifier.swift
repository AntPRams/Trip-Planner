import SwiftUI

struct BackgroundModifier: ViewModifier {
    
    var applyShadow: Bool
    
    init(applyShadow: Bool = true) {
        self.applyShadow = applyShadow
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                    .shadow(color: applyShadow ? .secondary : .clear, radius: 1)
            )
    }
}
