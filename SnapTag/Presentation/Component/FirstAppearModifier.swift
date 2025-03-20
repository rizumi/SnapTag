import SwiftUI

struct FirstAppearModifier: ViewModifier {
    let perform: () -> Void
    @State private var isFirstTime = true

    func body(content: Content) -> some View {
        content
            .onAppear {
                if isFirstTime {
                    isFirstTime = false
                    perform()
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(perform: perform))
    }
}
