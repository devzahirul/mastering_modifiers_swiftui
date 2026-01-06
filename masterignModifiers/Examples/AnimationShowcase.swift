//
//  AnimationShowcase.swift
//  masterignModifiers
//
//  Showcase of animation modifiers
//

import SwiftUI

struct AnimationShowcase: View {
    @State private var shakeTriggered = false
    @State private var bounceTriggered = false
    @State private var isPulsing = false
    @State private var isWiggling = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            Text("Animation Modifiers")
                .font(.largeTitle.weight(.bold))
                .slideIn(from: .top)
            
            // Shake Animation
            VStack(spacing: DesignSystem.Spacing.sm.rawValue) {
                Text("Shake Animation")
                    .font(.headline)
                
                TextField("Email", text: .constant("invalid@email"))
                    .textFieldStyle(.roundedBorder)
                    .shake(trigger: shakeTriggered)
                
                Button("Trigger Shake") {
                    shakeTriggered.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shakeTriggered = false
                    }
                }
                .dsButtonStyle(.secondary, size: .small)
            }
            .card()
            .fadeIn(delay: 0.1)
            
            // Bounce Animation
            VStack(spacing: DesignSystem.Spacing.sm.rawValue) {
                Text("Bounce Animation")
                    .font(.headline)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                    .bounce(trigger: bounceTriggered)
                
                Button("Trigger Bounce") {
                    bounceTriggered.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        bounceTriggered = false
                    }
                }
                .dsButtonStyle(.secondary, size: .small)
            }
            .card()
            .fadeIn(delay: 0.2)
            
            // Pulse Animation
            VStack(spacing: DesignSystem.Spacing.sm.rawValue) {
                Text("Pulse Animation")
                    .font(.headline)
                
                Circle()
                    .fill(DesignSystem.Colors.primary)
                    .frame(width: 60, height: 60)
                    .pulse(when: isPulsing)
                
                Button(isPulsing ? "Stop Pulse" : "Start Pulse") {
                    isPulsing.toggle()
                }
                .dsButtonStyle(.secondary, size: .small)
            }
            .card()
            .fadeIn(delay: 0.3)
            
            // Wiggle Animation
            VStack(spacing: DesignSystem.Spacing.sm.rawValue) {
                Text("Wiggle Animation")
                    .font(.headline)
                
                Image(systemName: "bell.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                    .wiggle(when: isWiggling)
                
                Button(isWiggling ? "Stop Wiggle" : "Start Wiggle") {
                    isWiggling.toggle()
                }
                .dsButtonStyle(.secondary, size: .small)
            }
            .card()
            .fadeIn(delay: 0.4)
        }
        .spacing(.lg)
    }
}

#Preview {
    ScrollView {
        AnimationShowcase()
    }
}
