//
//  AnimationModifiers.swift
//  masterignModifiers
//
//  Animation-aware modifiers using Animatable protocol
//

import SwiftUI

// MARK: - Shake Modifier

struct ShakeModifier: ViewModifier, Animatable {
    var shakeCount: CGFloat
    
    var animatableData: CGFloat {
        get { shakeCount }
        set { shakeCount = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: sin(shakeCount * .pi * 2) * 10)
    }
}

extension View {
    func shake(trigger: Bool) -> some View {
        modifier(ShakeModifier(shakeCount: trigger ? 3 : 0))
            .animation(.easeInOut(duration: 0.4), value: trigger)
    }
}

// MARK: - Pulse Modifier

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    withAnimation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPulsing = false
                    }
                }
            }
    }
}

extension View {
    func pulse(when active: Bool) -> some View {
        modifier(PulseModifier(isActive: active))
    }
}

// MARK: - Bounce Modifier

struct BounceModifier: ViewModifier, Animatable {
    var bounceValue: CGFloat
    
    var animatableData: CGFloat {
        get { bounceValue }
        set { bounceValue = newValue }
    }
    
    func body(content: Content) -> some View {
        let scale = 1 + (sin(bounceValue * .pi) * 0.2)
        content
            .scaleEffect(scale)
    }
}

extension View {
    func bounce(trigger: Bool) -> some View {
        modifier(BounceModifier(bounceValue: trigger ? 1 : 0))
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: trigger)
    }
}

// MARK: - Wiggle Modifier

struct WiggleModifier: ViewModifier {
    @State private var isWiggling = false
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? 3 : -3))
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    withAnimation(
                        .easeInOut(duration: 0.15)
                        .repeatForever(autoreverses: true)
                    ) {
                        isWiggling = true
                    }
                } else {
                    withAnimation(.easeOut(duration: 0.1)) {
                        isWiggling = false
                    }
                }
            }
    }
}

extension View {
    func wiggle(when active: Bool) -> some View {
        modifier(WiggleModifier(isActive: active))
    }
}

// MARK: - Fade In Modifier

struct FadeInModifier: ViewModifier {
    @State private var opacity: Double = 0
    let delay: Double
    let duration: Double
    
    init(delay: Double = 0, duration: Double = 0.3) {
        self.delay = delay
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: duration).delay(delay)) {
                    opacity = 1
                }
            }
    }
}

extension View {
    func fadeIn(delay: Double = 0, duration: Double = 0.3) -> some View {
        modifier(FadeInModifier(delay: delay, duration: duration))
    }
}

// MARK: - Slide In Modifier

struct SlideInModifier: ViewModifier {
    @State private var offset: CGFloat = 50
    @State private var opacity: Double = 0
    
    let edge: Edge
    let delay: Double
    
    init(from edge: Edge = .bottom, delay: Double = 0) {
        self.edge = edge
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: edge == .leading ? -offset : (edge == .trailing ? offset : 0),
                y: edge == .top ? -offset : (edge == .bottom ? offset : 0)
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(delay)) {
                    offset = 0
                    opacity = 1
                }
            }
    }
}

extension View {
    func slideIn(from edge: Edge = .bottom, delay: Double = 0) -> some View {
        modifier(SlideInModifier(from: edge, delay: delay))
    }
}
