//
//  EnvironmentAwareModifiers.swift
//  masterignModifiers
//
//  Modifiers that adapt to SwiftUI's environment
//

import SwiftUI

// MARK: - Adaptive Text Modifier

struct AdaptiveTextModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    func body(content: Content) -> some View {
        content
            .font(adaptiveFont)
            .foregroundColor(adaptiveColor)
            .lineSpacing(adaptiveLineSpacing)
    }
    
    private var adaptiveFont: Font {
        let baseSize: CGFloat = horizontalSizeClass == .regular ? 18 : 16
        
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            return .system(size: baseSize * 1.5, weight: .medium, design: .rounded)
        case .accessibilityExtraExtraLarge, .accessibilityExtraLarge:
            return .system(size: baseSize * 1.3, weight: .medium, design: .rounded)
        default:
            return .system(size: baseSize, weight: .regular, design: .default)
        }
    }
    
    private var adaptiveColor: Color {
        colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.85)
    }
    
    private var adaptiveLineSpacing: CGFloat {
        sizeCategory.isAccessibilityCategory ? 8 : 4
    }
}

extension View {
    func adaptiveText() -> some View {
        modifier(AdaptiveTextModifier())
    }
}

// MARK: - Theme-Aware Card Modifier

struct ThemeAwareCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let cornerRadius: DesignSystem.CornerRadius
    let shadow: DesignSystem.Shadow
    
    init(
        cornerRadius: DesignSystem.CornerRadius = .lg,
        shadow: DesignSystem.Shadow = .md
    ) {
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .smoothCorners(cornerRadius)
            .elevation(shadow)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius.rawValue, style: .continuous)
                    .stroke(borderColor, lineWidth: 0.5)
            }
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(.systemGray6)
            : .white
    }
    
    private var borderColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.1)
            : Color.black.opacity(0.05)
    }
}

extension View {
    func themeAwareCard(
        cornerRadius: DesignSystem.CornerRadius = .lg,
        shadow: DesignSystem.Shadow = .md
    ) -> some View {
        modifier(ThemeAwareCardModifier(cornerRadius: cornerRadius, shadow: shadow))
    }
}

// MARK: - Reduced Motion Modifier

struct ReducedMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let animation: Animation
    let reducedAnimation: Animation
    
    init(
        animation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        reducedAnimation: Animation = .linear(duration: 0.15)
    ) {
        self.animation = animation
        self.reducedAnimation = reducedAnimation
    }
    
    func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? reducedAnimation : animation, value: UUID())
    }
}

extension View {
    func accessibleAnimation(
        _ animation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        reduced: Animation = .linear(duration: 0.15)
    ) -> some View {
        modifier(ReducedMotionModifier(animation: animation, reducedAnimation: reduced))
    }
}
