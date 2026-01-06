//
//  ConditionalModifiers.swift
//  masterignModifiers
//
//  Conditional modifier patterns with type erasure
//

import SwiftUI

// MARK: - Basic Conditional Extension

extension View {
    /// Apply a modifier conditionally
    /// Usage: .if(isHighlighted) { $0.foregroundColor(.yellow) }
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply different modifiers based on condition
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: (Self) -> TrueContent,
        ifFalse: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
    
    /// Apply a modifier only if a value exists
    @ViewBuilder
    func ifLet<Value, Transform: View>(
        _ value: Value?,
        transform: (Self, Value) -> Transform
    ) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Type-Erased Conditional Modifier

struct ConditionalModifier<TrueModifier: ViewModifier, FalseModifier: ViewModifier>: ViewModifier {
    let condition: Bool
    let trueModifier: TrueModifier
    let falseModifier: FalseModifier
    
    func body(content: Content) -> some View {
        if condition {
            content.modifier(trueModifier)
        } else {
            content.modifier(falseModifier)
        }
    }
}

extension View {
    func conditionalModifier<T: ViewModifier, F: ViewModifier>(
        _ condition: Bool,
        ifTrue: T,
        ifFalse: F
    ) -> some View {
        modifier(ConditionalModifier(
            condition: condition,
            trueModifier: ifTrue,
            falseModifier: ifFalse
        ))
    }
}

// MARK: - Identity Modifier (for optional application)

struct IdentityModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    /// Apply a modifier only if the condition is true
    func modifier<M: ViewModifier>(
        _ modifier: M,
        if condition: Bool
    ) -> some View {
        conditionalModifier(condition, ifTrue: modifier, ifFalse: IdentityModifier())
    }
}
