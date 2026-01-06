//
//  ConditionalShowcase.swift
//  masterignModifiers
//
//  Showcase of conditional modifier patterns
//

import SwiftUI

struct ConditionalShowcase: View {
    @State private var isHighlighted = false
    @State private var isActive = false
    @State private var showBorder = false
    @State private var selectedStyle: Int = 0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            Text("Conditional Modifiers")
                .font(.largeTitle.weight(.bold))
            
            // Basic if Modifier
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Basic Conditional (.if)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Conditional Text")
                    .font(.title2)
                    .spacing(.md)
                    .if(isHighlighted) { view in
                        view
                            .foregroundColor(.yellow)
                            .background(Color.black)
                    }
                    .corners(.md)
                
                Toggle("Highlight", isOn: $isHighlighted)
            }
            .card()
            
            // If-Else Modifier
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("If-Else Conditional")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Circle()
                    .frame(width: 60, height: 60)
                    .if(isActive,
                        ifTrue: { $0.foregroundColor(.green).glow(.green) },
                        ifFalse: { $0.foregroundColor(.gray) }
                    )
                
                Toggle("Active", isOn: $isActive.animation())
            }
            .card()
            
            // Modifier with Condition
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Optional Modifier Application")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Styled Box")
                    .font(.headline)
                    .spacing(.lg)
                    .background(Color.blue.opacity(0.2))
                    .modifier(
                        StyledBorderModifier(
                            color: .blue,
                            width: 2,
                            cornerRadius: .lg
                        ),
                        if: showBorder
                    )
                    .corners(.lg)
                
                Toggle("Show Border", isOn: $showBorder.animation())
            }
            .card()
            
            // Composed Modifiers Demo
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Composed Modifiers")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Using + operator to compose")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                let composedStyle = CardModifier(padding: .md, cornerRadius: .lg, shadow: .md) +
                                   InteractiveModifier(isEnabled: true)
                
                Text("Composed Card")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .modifier(composedStyle)
            }
            .card()
        }
        .spacing(.lg)
    }
}

#Preview {
    ScrollView {
        ConditionalShowcase()
    }
}
