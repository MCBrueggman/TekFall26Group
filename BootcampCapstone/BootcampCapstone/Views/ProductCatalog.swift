//
//  ProductCatalog.swift
//  BootcampCapstone
//
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
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text(product.productNumber)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(product.listPrice.formatted(.currency(code: "USD")))
                    }
                }
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.filter)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, repository: viewModel.repository)
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
}

extension ProductCatalog {
    @Observable
    class ViewModel: Failable {

        let repository: any RepositoryProtocol<Product>
        init(repository: any RepositoryProtocol<Product>) {
            self.repository = repository
        }

        var errorMessage: String = ""
        var products: [Product] = []
        var filter: String = ""

        var filteredProducts: [Product] {
            let matches = filter.isEmpty ? products : products.filter {
                $0.name.localizedCaseInsensitiveContains(filter) ||
                $0.productNumber.localizedCaseInsensitiveContains(filter)
            }
            return matches.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }

        func loadProducts() async {
            do    { products = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}
