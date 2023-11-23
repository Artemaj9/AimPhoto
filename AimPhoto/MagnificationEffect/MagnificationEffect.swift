//
//  MagnificationEffect.swift
//

import SwiftUI

extension View {
    @ViewBuilder
    func magnificationEffect(_ scale: CGFloat, _ size: CGFloat = 0, _ tint: Color) -> some View {
        MagnificationEffectHelper(scale: scale, tint: tint, size: size) {
            self
        }
    }
}

struct MagnificationEffectHelper<Content: View>: View {
    
    var scale: CGFloat
    var size: CGFloat
    var tint: Color
    var content: Content
    
    init(scale: CGFloat, tint: Color, size: CGFloat, content: @escaping () -> Content) {
        self.scale = scale
        self.size = size
        self.tint = tint
        self.content = content()
    }
    
    @State var offset: CGSize = .zero
    @State var lastStoredOffset: CGSize = .zero
    @State var isOffset: Bool = false
    @State var midx: CGFloat = 0
    @State var midy: CGFloat = 0
    @State var y0: CGFloat = 0
    @State var x0: CGFloat = 0
    
    var body: some View {
        content
        .reverseMask(content: {
            let newCircleSize = 150.0 + size
            Circle()
            .frame(width: newCircleSize, height: newCircleSize)
            .offset(offset)
            })
            .overlay {
                GeometryReader { geo in
                    let newCircleSize = 150.0 + size
                    let size = geo.size
                    content
                    .offset(x: -offset.width, y: -offset.height)
                    .frame(width: newCircleSize, height: newCircleSize)
                    
                    .scaleEffect(1 + scale)
                    .clipShape(Circle())
                    .offset(offset)
                    .frame(width: size.width, height: size.height)
                    
                    GeometryReader { proxy in
                        Image(systemName: "plus")
                            .foregroundColor(.red)
                            .offset(offset)
                            .frame(width: size.width, height: size.height)
                    }
                    .frame(width: 20, height: 20)
                }
                .background(GeometryReader { gp -> Color in
                    let rect = gp.frame(in: .global)
                    
                    DispatchQueue.main.async {
                        midx = rect.midX
                        midy = rect.midY
                        coordinates.xCenter = rect.midX
                        coordinates.yCenter = rect.midY
                    }
                    return Color.clear
                })
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        
                        offset = CGSize(width: value.translation.width + lastStoredOffset.width, height: value.translation.height + lastStoredOffset.height)
                    }
                    .onEnded { _ in
                        lastStoredOffset = offset
                        coordinates.x = coordinates.xCenter + offset.width
                        coordinates.y = coordinates.yCenter + offset.height
                    }
            )
    }
}
