//
//  DesignTokens.swift
//  masterignModifiers
//
//  Design System Tokens with clean API extensions
//

import SwiftUI

// MARK: - Design Tokens with DesignSystem Namespace

enum DesignSystem {
    
    // MARK: - Spacing
    
    enum Spacing: CGFloat, CaseIterable {
        case xxs = 4
        case xs = 8
        case sm = 12
        case md = 16
        case lg = 24
        case xl = 32
        case xxl = 48
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius: CGFloat, CaseIterable {
        case sm = 4
        case md = 8
        case lg = 12
        case xl = 16
        case full = 9999
    }
    
    // MARK: - Shadow
    
    enum Shadow: CaseIterable {
        case none, sm, md, lg, xl
        
        var radius: CGFloat {
            switch self {
            case .none: return 0
            case .sm: return 2
            case .md: return 4
            case .lg: return 8
            case .xl: return 16
            }
        }
        
        var y: CGFloat {
            switch self {
            case .none: return 0
            case .sm: return 1
            case .md: return 2
            case .lg: return 4
            case .xl: return 8
            }
        }
        
        var opacity: Double {
            switch self {
            case .none: return 0
            case .sm: return 0.05
            case .md: return 0.1
            case .lg: return 0.15
            case .xl: return 0.2
            }
        }
    }
    
    // MARK: - Colors
    
    enum Colors {
        static let primary = Color.blue
        static let secondary = Color.purple
        static let success = Color.green
        static let warning = Color.orange
        static let danger = Color.red
        
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        
        static let backgroundPrimary = Color(.systemBackground)
        static let backgroundSecondary = Color(.secondarySystemBackground)
    }
}

// MARK: - View Extensions for Clean API

extension View {
    
    // MARK: - Spacing Extensions
    
    /// Apply padding using design system spacing
    /// Usage: .spacing(.md) instead of .padding(DesignSystem.Spacing.md)
    func spacing(_ value: DesignSystem.Spacing) -> some View {
        padding(value.rawValue)
    }
    
    /// Apply horizontal padding using design system spacing
    func spacingH(_ value: DesignSystem.Spacing) -> some View {
        padding(.horizontal, value.rawValue)
    }
    
    /// Apply vertical padding using design system spacing
    func spacingV(_ value: DesignSystem.Spacing) -> some View {
        padding(.vertical, value.rawValue)
    }
    
    /// Apply padding on specific edges using design system spacing
    func spacing(_ edges: Edge.Set, _ value: DesignSystem.Spacing) -> some View {
        padding(edges, value.rawValue)
    }
    
    // MARK: - Corner Radius Extensions
    
    /// Apply corner radius using design system values
    /// Usage: .corners(.lg) instead of .cornerRadius(DesignSystem.CornerRadius.lg)
    func corners(_ value: DesignSystem.CornerRadius) -> some View {
        clipShape(RoundedRectangle(cornerRadius: value.rawValue))
    }
    
    /// Apply continuous corner radius (smoother curves, iOS 13+)
    func smoothCorners(_ value: DesignSystem.CornerRadius) -> some View {
        clipShape(RoundedRectangle(cornerRadius: value.rawValue, style: .continuous))
    }
    
    // MARK: - Shadow Extensions
    
    /// Apply shadow using design system values
    /// Usage: .elevation(.md) instead of manually configuring shadow
    func elevation(_ value: DesignSystem.Shadow) -> some View {
        shadow(
            color: .black.opacity(value.opacity),
            radius: value.radius,
            x: 0,
            y: value.y
        )
    }
}

// MARK: - VStack/HStack Convenience Initializers

extension VStack {
    /// Create VStack with design system spacing
    init(
        alignment: HorizontalAlignment = .center,
        spacing: DesignSystem.Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

extension HStack {
    /// Create HStack with design system spacing
    init(
        alignment: VerticalAlignment = .center,
        spacing: DesignSystem.Spacing,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}
