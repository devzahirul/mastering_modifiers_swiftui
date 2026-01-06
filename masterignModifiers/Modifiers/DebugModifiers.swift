//
//  DebugModifiers.swift
//  masterignModifiers
//
//  Debug modifiers for development
//

import SwiftUI

// MARK: - Debug Modifier

struct DebugModifier: ViewModifier {
    let label: String
    let showBounds: Bool
    let showInfo: Bool
    let borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if showBounds {
                    GeometryReader { geo in
                        Rectangle()
                            .stroke(borderColor, lineWidth: 1)
                            .overlay(alignment: .topLeading) {
                                if showInfo {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(label)
                                            .fontWeight(.bold)
                                        Text("\(Int(geo.size.width))×\(Int(geo.size.height))")
                                    }
                                    .font(.caption2)
                                    .foregroundColor(borderColor)
                                    .padding(4)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(4)
                                    .offset(x: 2, y: 2)
                                }
                            }
                    }
                }
            }
    }
}

extension View {
    func debug(
        _ label: String = "Debug",
        showBounds: Bool = true,
        showInfo: Bool = true,
        color: Color = .red
    ) -> some View {
        #if DEBUG
        modifier(DebugModifier(
            label: label,
            showBounds: showBounds,
            showInfo: showInfo,
            borderColor: color
        ))
        #else
        self
        #endif
    }
}

// MARK: - Print Value Modifier

struct PrintValueModifier<Value>: ViewModifier {
    let label: String
    let value: Value
    
    func body(content: Content) -> some View {
        #if DEBUG
        let _ = print("[\(label)] \(value)")
        #endif
        return content
    }
}

extension View {
    func printValue<V>(_ label: String, _ value: V) -> some View {
        modifier(PrintValueModifier(label: label, value: value))
    }
}

// MARK: - Random Background Modifier (for layout debugging)

struct RandomBackgroundModifier: ViewModifier {
    let opacity: Double
    
    private var randomColor: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    func body(content: Content) -> some View {
        #if DEBUG
        content
            .background(randomColor.opacity(opacity))
        #else
        content
        #endif
    }
}

extension View {
    func randomBackground(opacity: Double = 0.3) -> some View {
        modifier(RandomBackgroundModifier(opacity: opacity))
    }
}

// MARK: - Render Count Modifier

struct RenderCountModifier: ViewModifier {
    let label: String
    @State private var renderCount = 0
    
    func body(content: Content) -> some View {
        #if DEBUG
        let _ = Self._printRender(&renderCount, label: label)
        #endif
        return content
    }
    
    #if DEBUG
    private static func _printRender(_ count: inout Int, label: String) {
        count += 1
        print("[\(label)] Render count: \(count)")
    }
    #endif
}

extension View {
    func trackRenders(_ label: String = "View") -> some View {
        modifier(RenderCountModifier(label: label))
    }
}
