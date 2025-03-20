import SwiftUI

struct JiggleModifier: ViewModifier {
    let isJiggling: Bool
    
    @State private var rotation: Angle = .zero
    @State private var offset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(isJiggling ? rotation : .zero)
            .offset(isJiggling ? offset : .zero)
            .onChange(of: isJiggling) { jiggling in
                guard jiggling else {
                    rotation = .zero
                    offset = .zero
                    return
                }
                
                withAnimation(
                    .easeInOut(duration: 0.15)
                    .repeatForever(autoreverses: true)
                ) {
                    rotation = .degrees([-2, 2][Int.random(in: 0...1)])
                    offset = CGSize(
                        width: [-1, 1][Int.random(in: 0...1)],
                        height: [-1, 1][Int.random(in: 0...1)]
                    )
                }
            }
    }
}