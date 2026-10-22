//
//  ProductDetailView.swift
//  BootcampCapstone
//  Created by Shawn Defibaugh on 9/27/26.
//  Modified by Mike Brueggman
//

import SwiftUI
import UIKit

struct ProductDetailView: View {
    let product: Product
    let repository: any RepositoryProtocol<Product>
    
    var body: some View {
        List {
            // Product Image Section
            if let photo = product.thumbnailPhoto,
               let photoFileName = product.thumbnailPhotoFileName,
               photoFileName != "no_image_available_small.gif",
               let image = photoConversion(photo) {
                Section {
                    HStack {
                        Spacer()
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 150)
                            .accessibilityLabel("Product photo of \(product.name)")
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            
            // Header Title & Price
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("List Price: \(product.listPrice.formatted(.currency(code: "USD")))")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(product.name), Price: \(product.listPrice.formatted(.currency(code: "USD")))")
            }
            
            if let summary = product.summary, !summary.isEmpty {
                Section("Summary") {
                    Text(summary)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Section("Details") {
                LabeledContent("Product ID:", value: "\(product.id)")
                    .accessibilityLabel("Product ID: \(product.id)")
                
                LabeledContent("Product Number:", value: product.productNumber)
                    .accessibilityLabel("Product Number: \(product.productNumber)")
                
                if let color = product.color, !color.isEmpty {
                    LabeledContent("Color:", value: color)
                        .accessibilityLabel("Color: \(color)")
                }
                
                if let warranty = product.warranty, !warranty.isEmpty {
                    LabeledContent("Warranty:", value: warranty)
                        .accessibilityLabel("Warranty: \(warranty)")
                }
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func photoConversion(_ base64: String) -> Image? {
        guard let data = Data(base64Encoded: base64), let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}