//
//  SegmentedIndicator.swift
//  masterignModifiers
//
//  Segmented control using preference keys for bounds collection
//

import SwiftUI

// MARK: - Segment Button

struct SegmentButton: View {
    let title: String
    let index: Int
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline.weight(isSelected ? .semibold : .regular))
            .foregroundColor(isSelected ? .primary : .secondary)
            .spacing(.md)
            .contentShape(Rectangle())
    }
}

// MARK: - Segmented Indicator

struct SegmentedIndicator: View {
    let segments: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(segments.enumerated()), id: \.offset) { index, title in
                    SegmentButton(
                        title: title,
                        index: index,
                        isSelected: selectedIndex == index
                    )
                    .collectBounds(at: index)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedIndex = index
                        }
                    }
                }
            }
            .overlayPreferenceValue(AnchorPreferenceKey<IndexedBoundsPreference>.self) { prefs in
                GeometryReader { geometry in
                    if let selected = prefs.first(where: { $0.index == selectedIndex }) {
                        Capsule()
                            .fill(DesignSystem.Colors.primary)
                            .frame(
                                width: geometry[selected.bounds].width,
                                height: 3
                            )
                            .offset(
                                x: geometry[selected.bounds].minX,
                                y: geometry[selected.bounds].maxY - 3
                            )
                    }
                }
            }
        }
        .background(Color(.systemGray6))
        .corners(.lg)
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var selected = 0
        
        var body: some View {
            VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
                SegmentedIndicator(
                    segments: ["All", "Active", "Completed", "Archived"],
                    selectedIndex: $selected
                )
                
                Text("Selected: \(selected)")
                    .font(.headline)
            }
            .spacing(.lg)
        }
    }
    
    return PreviewWrapper()
}
