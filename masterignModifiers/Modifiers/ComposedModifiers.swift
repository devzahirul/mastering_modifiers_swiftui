//
//  ComposedModifiers.swift
//  masterignModifiers
//
//  Modifier composition with generics and operators
//

import SwiftUI

// MARK: - Composed Modifier

struct ComposedModifier<First: ViewModifier, Second: ViewModifier>: ViewModifier {
    let first: First
    let second: Second
    
    func body(content: Content) -> some View {
        content
            .modifier(first)
            .modifier(second)
    }
}

// MARK: - Operator Overload for Elegant Composition

/// Allows: let style = CardModifier() + ShadowModifier() + BorderModifier()
func + <M1: ViewModifier, M2: ViewModifier>(
    lhs: M1,
    rhs: M2
) -> ComposedModifier<M1, M2> {
    ComposedModifier(first: lhs, second: rhs)
}

// MARK: - Optional Modifier

struct OptionalModifier<Wrapped: ViewModifier>: ViewModifier {
    let modifier: Wrapped?
    
    func body(content: Content) -> some View {
        if let modifier {
            content.modifier(modifier)
        } else {
            content
        }
    }
}

// MARK: - Either Modifier

enum EitherModifier<First: ViewModifier, Second: ViewModifier>: ViewModifier {
    case first(First)
    case second(Second)
    
    func body(content: Content) -> some View {
        switch self {
        case .first(let modifier):
            content.modifier(modifier)
        case .second(let modifier):
            content.modifier(modifier)
        }
    }
}

// MARK: - Result Builder for Modifier Composition

@resultBuilder
struct ModifierBuilder {
    static func buildBlock<M: ViewModifier>(_ modifier: M) -> M {
        modifier
    }
    
    static func buildBlock<M1: ViewModifier, M2: ViewModifier>(
        _ m1: M1,
        _ m2: M2
    ) -> ComposedModifier<M1, M2> {
        ComposedModifier(first: m1, second: m2)
    }
    
    static func buildBlock<M1: ViewModifier, M2: ViewModifier, M3: ViewModifier>(
        _ m1: M1,
        _ m2: M2,
        _ m3: M3
    ) -> ComposedModifier<ComposedModifier<M1, M2>, M3> {
        ComposedModifier(first: ComposedModifier(first: m1, second: m2), second: m3)
    }
    
    static func buildOptional<M: ViewModifier>(_ modifier: M?) -> OptionalModifier<M> {
        OptionalModifier(modifier: modifier)
    }
    
    static func buildEither<TrueModifier: ViewModifier, FalseModifier: ViewModifier>(
        first: TrueModifier
    ) -> EitherModifier<TrueModifier, FalseModifier> {
        .first(first)
    }
    
    static func buildEither<TrueModifier: ViewModifier, FalseModifier: ViewModifier>(
        second: FalseModifier
    ) -> EitherModifier<TrueModifier, FalseModifier> {
        .second(second)
    }
}

// MARK: - View Extension for Result Builder

extension View {
    /// Apply modifiers using result builder syntax
    func styled(@ModifierBuilder _ builder: () -> some ViewModifier) -> some View {
        modifier(builder())
    }
}
