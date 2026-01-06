//
//  ButtonStyleModifiers.swift
//  masterignModifiers
//
//  Protocol-oriented button style architecture
//

import SwiftUI

// MARK: - Button Style Enum

enum DSButtonStyle {
    case primary
    case secondary
    case destructive
    case ghost
    case outline
}

// MARK: - Button Style Modifier

struct DSButtonStyleModifier: ViewModifier {
    let style: DSButtonStyle
    let size: ButtonSize
    
    @Environment(\.isEnabled) private var isEnabled
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var horizontalPadding: DesignSystem.Spacing {
            switch self {
            case .small: return .sm
            case .medium: return .lg
            case .large: return .xl
            }
        }
        
        var verticalPadding: DesignSystem.Spacing {
            switch self {
            case .small: return .xs
            case .medium: return .sm
            case .large: return .md
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .subheadline.weight(.semibold)
            case .medium: return .headline
            case .large: return .title3.weight(.semibold)
            }
        }
    }
    
    init(style: DSButtonStyle, size: ButtonSize = .medium) {
        self.style = style
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content
            .font(size.font)
            .spacingH(size.horizontalPadding)
            .spacingV(size.verticalPadding)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .overlay {
                if style == .outline {
                    Capsule()
                        .stroke(DesignSystem.Colors.primary, lineWidth: 2)
                }
            }
            .clipShape(Capsule())
            .opacity(isEnabled ? 1.0 : 0.5)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return DesignSystem.Colors.primary
        case .destructive: return .white
        case .ghost: return DesignSystem.Colors.primary
        case .outline: return DesignSystem.Colors.primary
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return DesignSystem.Colors.primary
        case .secondary: return DesignSystem.Colors.primary.opacity(0.1)
        case .destructive: return DesignSystem.Colors.danger
        case .ghost: return .clear
        case .outline: return .clear
        }
    }
}

extension View {
    func dsButtonStyle(
        _ style: DSButtonStyle,
        size: DSButtonStyleModifier.ButtonSize = .medium
    ) -> some View {
        modifier(DSButtonStyleModifier(style: style, size: size))
    }
}

// MARK: - Interactive Button Wrapper

struct InteractiveButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    @State private var isPressed = false
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        label()
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in
                        isPressed = false
                        action()
                    }
            )
    }
}
