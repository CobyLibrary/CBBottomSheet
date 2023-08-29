import SwiftUI

public struct CBBottomSheet<Content: View>: View {
    @State private var currentOffset: CGFloat = 0
    @State private var endOffset: CGFloat = 0
    
    private var minHeight: CGFloat
    private var maxHeight: CGFloat
    private var maxOffset: CGFloat {
        UIScreen.main.bounds.height + Self.topPadding() - maxHeight
    }
    private var startingOffset: CGFloat {
        UIScreen.main.bounds.height + Self.topPadding() - minHeight
    }
    
    private var backgroundColor: Color
    private var indicatorBackgroundColor: Color
    
    private var content: () -> Content
    
    public static func topPadding() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        return topPadding
    }
    
    public static func bottomPadding() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return bottomPadding
    }
    
    public init(
        minHeight: CGFloat,
        maxHeight: CGFloat = UIScreen.main.bounds.height + Self.bottomPadding(),
        backgroundColor: Color = Color.backgroundPrimary,
        indicatorBackgroundColor: Color = Color.backgroundPrimary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        
        self.backgroundColor = backgroundColor
        self.indicatorBackgroundColor = indicatorBackgroundColor
        
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .foregroundColor(.grayscale400)
                .frame(width: 40, height: 6)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(indicatorBackgroundColor)
            
            content()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(TopRoundedShape(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: -10)
        .edgesIgnoringSafeArea(.bottom)
        .offset(y: startingOffset)
        .offset(y: currentOffset)
        .offset(y: endOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    withAnimation(.spring()) {
                        currentOffset = value.translation.height
                        if endOffset == 0 && startingOffset + currentOffset < maxOffset {
                            currentOffset = maxOffset - startingOffset
                        } else if endOffset != 0 && currentOffset < 0 {
                            currentOffset = 0
                        }
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if currentOffset < -(maxHeight-minHeight)/2 {
                            endOffset = -(maxHeight-minHeight)
                        } else if endOffset != 0 && currentOffset > (maxHeight-minHeight)/2 {
                            endOffset = 0
                        }
                        currentOffset = 0
                    }
                }
        )
    }
}

public struct TopRoundedShape: Shape {
    var cornerRadius: CGFloat
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: .init(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(center: .init(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.addLine(to: .init(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: .init(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false)
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

extension Color {
    @nonobjc public static var backgroundPrimary: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 13.0 / 255.0, green: 14.0 / 255.0, blue: 19.0 / 255.0, alpha: 1.0)
            default: return UIColor(white: 1.0, alpha: 1.0)
            }
        })
    }
    
    @nonobjc public static var grayscale400: Color {
        return Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(white: 1.0, alpha: 0.24)
            default: return UIColor(white: 183.0 / 255.0, alpha: 1.0)
            }
        })
    }
}
