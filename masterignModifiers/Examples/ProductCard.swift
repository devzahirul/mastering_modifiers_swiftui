//
//  ProductCard.swift
//  masterignModifiers
//
//  Production example using component modifiers
//

import SwiftUI

// MARK: - Product Model

struct Product: Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let imageName: String
    let rating: Double
    let reviewCount: Int
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
    
    static let samples: [Product] = [
        Product(id: UUID(), name: "Premium Wireless Headphones", price: 299.99, imageName: "headphones", rating: 4.8, reviewCount: 1234),
        Product(id: UUID(), name: "Smart Watch Pro", price: 449.99, imageName: "applewatch", rating: 4.6, reviewCount: 892),
        Product(id: UUID(), name: "Portable Speaker", price: 129.99, imageName: "hifispeaker", rating: 4.4, reviewCount: 567),
        Product(id: UUID(), name: "Wireless Earbuds", price: 199.99, imageName: "earbuds", rating: 4.7, reviewCount: 2341),
    ]
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    @State private var isLoading = false
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm.rawValue) {
            // Image Section
            ZStack(alignment: .topTrailing) {
                Image(systemName: product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
                    .background(Color(.systemGray6))
                    .corners(.md)
                
                // Favorite Button
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .spacing(.xs)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .bounce(trigger: isFavorite)
                .padding(8)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxs.rawValue) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack(spacing: DesignSystem.Spacing.xxs.rawValue) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption.weight(.medium))
                    
                    Text("(\(product.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(product.formattedPrice)
                    .font(.title3.weight(.bold))
                    .foregroundColor(DesignSystem.Colors.primary)
            }
        }
        .card(shadow: .sm)
        .interactive()
        .loadingOverlay(isLoading)
    }
}

// MARK: - Product Grid

struct ProductGrid: View {
    let products: [Product]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCard(product: product)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        ProductGrid(products: Product.samples)
            .spacing(.md)
    }
}
