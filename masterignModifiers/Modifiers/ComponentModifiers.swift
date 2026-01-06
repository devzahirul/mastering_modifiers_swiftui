//
//  ComponentModifiers.swift
//  masterignModifiers
//
//  Production-ready component modifiers
//

import SwiftUI

// MARK: - Card Modifier

struct CardModifier: ViewModifier {
    let padding: DesignSystem.Spacing
    let cornerRadius: DesignSystem.CornerRadius
    let shadow: DesignSystem.Shadow
    let backgroundColor: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(
        padding: DesignSystem.Spacing = .md,
        cornerRadius: DesignSystem.CornerRadius = .lg,
        shadow: DesignSystem.Shadow = .md,
        backgroundColor: Color = .white
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .spacing(padding)
            .background(adaptiveBackground)
            .corners(cornerRadius)
            .elevation(shadow)
    }
    
    private var adaptiveBackground: Color {
        colorScheme == .dark
            ? Color(.systemGray6)
            : backgroundColor
    }
}

extension View {
    func card(
        padding: DesignSystem.Spacing = .md,
        cornerRadius: DesignSystem.CornerRadius = .lg,
        shadow: DesignSystem.Shadow = .md,
        backgroundColor: Color = .white
    ) -> some View {
        modifier(CardModifier(
            padding: padding,
            cornerRadius: cornerRadius,
            shadow: shadow,
            backgroundColor: backgroundColor
        ))
    }
}

// MARK: - Interactive Modifier

struct InteractiveModifier: ViewModifier {
    let isEnabled: Bool
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.5)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        guard isEnabled else { return }
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
}

extension View {
    func interactive(isEnabled: Bool = true) -> some View {
        modifier(InteractiveModifier(isEnabled: isEnabled))
    }
}

// MARK: - Loading Overlay Modifier

struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    let message: String?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(.white)
                            
                            if let message {
                                Text(message)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                        .spacing(.lg)
                        .background(.ultraThinMaterial)
                        .corners(.lg)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, message: String? = nil) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading, message: message))
    }
}

// MARK: - Border Modifier

struct StyledBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let cornerRadius: DesignSystem.CornerRadius
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius.rawValue, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
}

extension View {
    func styledBorder(
        _ color: Color = .secondary.opacity(0.3),
        width: CGFloat = 1,
        cornerRadius: DesignSystem.CornerRadius = .lg
    ) -> some View {
        modifier(StyledBorderModifier(color: color, width: width, cornerRadius: cornerRadius))
    }
}

// MARK: - Glow Modifier

struct GlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.5), radius: radius / 2)
            .shadow(color: color.opacity(0.3), radius: radius)
            .shadow(color: color.opacity(0.1), radius: radius * 2)
    }
}

extension View {
    func glow(_ color: Color = .blue, radius: CGFloat = 10) -> some View {
        modifier(GlowModifier(color: color, radius: radius))
    }
}

// MARK: - Badge Modifier

struct BadgeModifier: ViewModifier {
    let count: Int
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                if count > 0 {
                    Text(count > 99 ? "99+" : "\(count)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(color)
                        .clipShape(Capsule())
                        .offset(x: 8, y: -8)
                }
            }
    }
}

extension View {
    func badge(_ count: Int, color: Color = .red) -> some View {
        modifier(BadgeModifier(count: count, color: color))
    }
}

// MARK: - Shimmer Modifier (Loading Placeholder)

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.5),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            }
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
