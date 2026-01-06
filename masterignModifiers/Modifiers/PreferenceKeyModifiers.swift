//
//  PreferenceKeyModifiers.swift
//  masterignModifiers
//
//  Preference keys for child-to-parent communication
//

import SwiftUI

// MARK: - Size Preference Key

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Measure Size Modifier

struct MeasureSizeModifier: ViewModifier {
    let onSizeChange: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self, perform: onSizeChange)
    }
}

extension View {
    func measureSize(_ onSizeChange: @escaping (CGSize) -> Void) -> some View {
        modifier(MeasureSizeModifier(onSizeChange: onSizeChange))
    }
}

// MARK: - Anchor Preference Key for Multiple Values

struct AnchorPreferenceKey<Value>: PreferenceKey {
    static var defaultValue: [Value] { [] }
    
    static func reduce(value: inout [Value], nextValue: () -> [Value]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Indexed Bounds Preference

struct IndexedBoundsPreference: Equatable {
    let index: Int
    let bounds: Anchor<CGRect>
}

// MARK: - Collect Bounds Modifier

struct CollectBoundsModifier: ViewModifier {
    let index: Int
    
    func body(content: Content) -> some View {
        content
            .anchorPreference(
                key: AnchorPreferenceKey<IndexedBoundsPreference>.self,
                value: .bounds
            ) { anchor in
                [IndexedBoundsPreference(index: index, bounds: anchor)]
            }
    }
}

extension View {
    func collectBounds(at index: Int) -> some View {
        modifier(CollectBoundsModifier(index: index))
    }
}

// MARK: - Frame Preference Key

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - Read Frame Modifier

struct ReadFrameModifier: ViewModifier {
    let coordinateSpace: CoordinateSpace
    let onFrameChange: (CGRect) -> Void
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: FramePreferenceKey.self,
                            value: geometry.frame(in: coordinateSpace)
                        )
                }
            )
            .onPreferenceChange(FramePreferenceKey.self, perform: onFrameChange)
    }
}

extension View {
    func readFrame(
        in coordinateSpace: CoordinateSpace = .global,
        onChange: @escaping (CGRect) -> Void
    ) -> some View {
        modifier(ReadFrameModifier(coordinateSpace: coordinateSpace, onFrameChange: onChange))
    }
}
