//
//  AdvancedCardModifier.swift
//  masterignModifiers
//
//  Advanced card modifier from the article
//

import SwiftUI

// MARK: - Advanced Card Modifier

struct AdvancedCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: .black.opacity(0.15),
                radius: shadowRadius,
                x: 0,
                y: shadowRadius / 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

extension View {
    func advancedCard(
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 8
    ) -> some View {
        modifier(AdvancedCardModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}
