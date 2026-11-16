//
//  ProductDetailView.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

import SwiftUI
import UIKit

struct ProductDetailView: View {
    let product: Product
    let repository: any RepositoryProtocol<Product>

    var body: some View {
        VStack {
            Text(product.name)
                .font(.largeTitle)
                .bold()
            List {
                Section {
                    if let photo = product.thumbnailPhoto,
                       let photoFileName = product.thumbnailPhotoFileName,
                       photoFileName != "no_image_available_small.gif",
                       let image = photoConversion(photo) {
                        HStack {
                            Spacer()
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .accessibilityLabel("image of \(product.name)")
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .listRowInsets(EdgeInsets())
                    }
                }
                Section("Price") {
                    Text("\(product.listPrice.formatted(.currency(code: "USD")))")
                }
                if let summary = product.summary, !summary.isEmpty {
                    Section("Summary") {
                        Text(summary)
                    }
                }
                Section("Details") {
                    LabeledContent("Product ID:", value: "\(product.id)")
                    LabeledContent("Product Number:", value: product.productNumber)
                    if let color = product.color, !color.isEmpty {
                        LabeledContent("Color:", value: color)
                    }
                    if let warranty = product.warranty, !warranty.isEmpty {
                        LabeledContent("Warranty:", value: warranty)
                    }
                }
            }
            .listSectionSpacing(4)
            
        }
    }
}

// needed to convert image from base 64
private func photoConversion(_ base64: String) -> Image? {
    guard let data = Data(base64Encoded: base64), let uiImage = UIImage(data: data) else {
        return nil
    }

    return Image(uiImage: uiImage)
}
