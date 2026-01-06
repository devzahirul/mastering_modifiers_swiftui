//
//  EffectsShowcase.swift
//  masterignModifiers
//
//  Showcase of visual effect modifiers
//

import SwiftUI

struct EffectsShowcase: View {
    @State private var badgeCount = 5
    @State private var isShimmering = true
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            Text("Visual Effects")
                .font(.largeTitle.weight(.bold))
            
            // Glow Effect
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Glow Effect")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: DesignSystem.Spacing.lg.rawValue) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .glow(.blue, radius: 10)
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                        .glow(.green, radius: 10)
                    
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 50, height: 50)
                        .glow(.purple, radius: 10)
                }
            }
            .card()
            
            // Badge Effect
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Badge Modifier")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: DesignSystem.Spacing.xl.rawValue) {
                    Image(systemName: "bell.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .badge(badgeCount)
                    
                    Image(systemName: "envelope.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .badge(12)
                    
                    Image(systemName: "cart.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .badge(100) // Shows "99+"
                }
                
                Stepper("Badge Count: \(badgeCount)", value: $badgeCount, in: 0...20)
            }
            .card()
            
            // Shimmer Effect
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Shimmer Loading Effect")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm.rawValue) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .if(isShimmering) { $0.shimmer() }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .frame(width: 200)
                        .if(isShimmering) { $0.shimmer() }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .frame(width: 150)
                        .if(isShimmering) { $0.shimmer() }
                }
                
                Toggle("Shimmer Active", isOn: $isShimmering)
            }
            .card()
            
            // Elevation Levels
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Elevation Levels")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: DesignSystem.Spacing.md.rawValue) {
                    ForEach(DesignSystem.Shadow.allCases, id: \.self) { shadow in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                                .elevation(shadow)
                            
                            Text("\(shadow)")
                                .font(.caption2)
                        }
                    }
                }
            }
            .card()
            
            // Corner Radius Showcase
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Corner Radius Levels")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: DesignSystem.Spacing.md.rawValue) {
                    ForEach(DesignSystem.CornerRadius.allCases, id: \.self) { radius in
                        if radius != .full {
                            VStack {
                                RoundedRectangle(cornerRadius: radius.rawValue)
                                    .fill(DesignSystem.Colors.primary.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                
                                Text("\(radius)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
            .card()
        }
        .spacing(.lg)
    }
}

#Preview {
    ScrollView {
        EffectsShowcase()
    }
}
