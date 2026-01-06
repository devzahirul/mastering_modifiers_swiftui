//
//  ButtonShowcase.swift
//  masterignModifiers
//
//  Showcase of button style modifiers
//

import SwiftUI

struct ButtonShowcase: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            Text("Button Styles")
                .font(.largeTitle.weight(.bold))
            
            // Button Styles
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Style Variants")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Primary Button") {}
                    .dsButtonStyle(.primary)
                    .interactive()
                
                Button("Secondary Button") {}
                    .dsButtonStyle(.secondary)
                    .interactive()
                
                Button("Destructive Button") {}
                    .dsButtonStyle(.destructive)
                    .interactive()
                
                Button("Ghost Button") {}
                    .dsButtonStyle(.ghost)
                    .interactive()
                
                Button("Outline Button") {}
                    .dsButtonStyle(.outline)
                    .interactive()
            }
            .card()
            
            // Button Sizes
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Size Variants")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: DesignSystem.Spacing.md.rawValue) {
                    Button("Small") {}
                        .dsButtonStyle(.primary, size: .small)
                    
                    Button("Medium") {}
                        .dsButtonStyle(.primary, size: .medium)
                    
                    Button("Large") {}
                        .dsButtonStyle(.primary, size: .large)
                }
            }
            .card()
            
            // Disabled State
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Disabled State")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Disabled Primary") {}
                    .dsButtonStyle(.primary)
                    .disabled(true)
                
                Button("Disabled Secondary") {}
                    .dsButtonStyle(.secondary)
                    .disabled(true)
            }
            .card()
            
            // Loading Button
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Loading State")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                } label: {
                    HStack(spacing: DesignSystem.Spacing.sm.rawValue) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(isLoading ? "Loading..." : "Submit")
                    }
                }
                .dsButtonStyle(.primary)
                .disabled(isLoading)
            }
            .card()
        }
        .spacing(.lg)
    }
}

#Preview {
    ScrollView {
        ButtonShowcase()
    }
}
