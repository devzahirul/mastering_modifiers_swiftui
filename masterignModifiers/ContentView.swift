//
//  ContentView.swift
//  masterignModifiers
//
//  Main view showcasing all view modifier patterns
//

import SwiftUI

// MARK: - Tab Enum

enum ShowcaseTab: String, CaseIterable {
    case overview = "Overview"
    case buttons = "Buttons"
    case animations = "Animations"
    case effects = "Effects"
    case conditional = "Conditional"
    case products = "Products"
    
    var icon: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .buttons: return "hand.tap"
        case .animations: return "sparkles"
        case .effects: return "wand.and.stars"
        case .conditional: return "questionmark.circle"
        case .products: return "bag"
        }
    }
}

// MARK: - Content View

struct ContentView: View {
    @State private var selectedTab: ShowcaseTab = .overview
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                    NavigationStack {
                        ScrollView {
                            tabContent(for: tab)
                        }
                        .navigationTitle(tab.rawValue)
                    }
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.icon)
                    }
                    .tag(tab)
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabContent(for tab: ShowcaseTab) -> some View {
        switch tab {
        case .overview:
            OverviewShowcase()
        case .buttons:
            ButtonShowcase()
        case .animations:
            AnimationShowcase()
        case .effects:
            EffectsShowcase()
        case .conditional:
            ConditionalShowcase()
        case .products:
            ProductsShowcase()
        }
    }
}

// MARK: - Overview Showcase

struct OverviewShowcase: View {
    @State private var measuredSize: CGSize = .zero
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            // Hero Section
            VStack(spacing: DesignSystem.Spacing.md.rawValue) {
                Image(systemName: "swift")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .glow(.orange, radius: 15)
                    .slideIn(from: .top)
                
                Text("Mastering View Modifiers")
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .fadeIn(delay: 0.1)
                
                Text("A comprehensive SwiftUI modifier system")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fadeIn(delay: 0.2)
            }
            .spacing(.xl)
            
            // Design System Tokens
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Design Tokens")
                    .font(.headline)
                
                Text("Clean API through View extensions:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm.rawValue) {
                    codeExample(".spacing(.md)", "Design system padding")
                    codeExample(".corners(.lg)", "Consistent corner radius")
                    codeExample(".elevation(.md)", "Material shadows")
                }
            }
            .card()
            .fadeIn(delay: 0.3)
            
            // Size Measurement Demo
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Preference Keys")
                    .font(.headline)
                
                Text("Child-to-parent communication:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Measure this text")
                    .font(.title2)
                    .spacing(.lg)
                    .background(DesignSystem.Colors.primary.opacity(0.1))
                    .corners(.md)
                    .measureSize { size in
                        measuredSize = size
                    }
                
                Text("Measured size: \(Int(measuredSize.width))×\(Int(measuredSize.height))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .card()
            .fadeIn(delay: 0.4)
            
            // Segmented Indicator Demo
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Bounds Collection")
                    .font(.headline)
                
                SegmentedDemo()
            }
            .card()
            .fadeIn(delay: 0.5)
            
            // Loading Overlay Demo
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md.rawValue) {
                Text("Loading Overlay")
                    .font(.headline)
                
                Button("Trigger Loading (2s)") {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                .dsButtonStyle(.primary)
            }
            .card()
            .loadingOverlay(isLoading, message: "Please wait...")
            .fadeIn(delay: 0.6)
        }
        .spacing(.lg)
    }
    
    private func codeExample(_ code: String, _ description: String) -> some View {
        HStack {
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(DesignSystem.Colors.primary)
                .spacing(.xs)
                .background(DesignSystem.Colors.primary.opacity(0.1))
                .corners(.sm)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Segmented Demo

struct SegmentedDemo: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md.rawValue) {
            SegmentedIndicator(
                segments: ["All", "Active", "Done"],
                selectedIndex: $selectedIndex
            )
            
            Text("Selected: \(selectedIndex)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Products Showcase

struct ProductsShowcase: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl.rawValue) {
            Text("Product Cards")
                .font(.largeTitle.weight(.bold))
                .slideIn(from: .top)
            
            Text("Production-ready component example")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProductGrid(products: Product.samples)
        }
        .spacing(.lg)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
