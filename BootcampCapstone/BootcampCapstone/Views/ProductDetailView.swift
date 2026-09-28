//
//  ProductDetailView.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    let repository: any RepositoryProtocol<Product>

    var body: some View {
        VStack {
            Text(product.name)
                .font(.largeTitle)
                .bold()
            List {
                LabeledContent("Product ID:", value: "\(product.id)")
                LabeledContent("Product Number:", value: product.productNumber)
                LabeledContent("Price:", value: product.listPrice.formatted(.currency(code: "USD")))
                if let color = product.color, !color.isEmpty {
                    LabeledContent("Color:", value: color)
                }
                if let warranty = product.warranty, !warranty.isEmpty {
                    LabeledContent("Warranty:", value: warranty)
                }
                if let summary = product.summary, !summary.isEmpty {
                    Section("Summary") {
                        Text(summary)
                    }
                }
            }
        }
    }
}
