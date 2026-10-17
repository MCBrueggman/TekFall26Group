//
//  ProductCatalog.swift
//  BootcampCapstone
//  Created by Shawn Defibaugh on 9/27/26.
//

import SwiftUI

struct ProductCatalog: View {
    @State var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<Product>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.filteredProducts) { product in
                NavigationLink(value: product) {
                    ViewThatFits {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(product.name)
                                    .font(.headline)
                                Text("SKU: \(product.productNumber)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(product.listPrice.formatted(.currency(code: "USD")))
                                .font(.body)
                                .bold()
                                .monospacedDigit()
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.headline)
                            Text("SKU: \(product.productNumber)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(product.listPrice.formatted(.currency(code: "USD")))
                                .font(.body)
                                .bold()
                        }
                    }
                }
                .frame(minHeight: 44) // Standard hit target height
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(product.name), Product number \(product.productNumber), Price: \(product.listPrice.formatted(.currency(code: "USD")))")
                .accessibilityHint("Double tap to view full product details")
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.filter, prompt: "Search products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sorting) {
                            ForEach(SortingProducts.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                            .frame(width: 44, height: 44) // Enforce min tap target size
                    }
                    .accessibilityLabel("Sort options")
                    .accessibilityHint("Select sorting criteria for products")
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, repository: viewModel.repository)
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
}