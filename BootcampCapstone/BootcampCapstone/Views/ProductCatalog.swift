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
            VStack(spacing: 0) {
                // MARK: - Active Criteria Bar
                if viewModel.isFiltered {
                    HStack {
                        Text("Active Criteria:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if viewModel.sortOption != .defaultSort {
                            Text(viewModel.sortOption.label)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.12))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Button("Clear Criteria") {
                            viewModel.clearCriteria()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.secondarySystemBackground))
                }
                
                // MARK: - Product List
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
                                .monospacedDigit()
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .searchable(text: $viewModel.filter, prompt: "Search name or product number")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort By Price", selection: $viewModel.sortOption) {
                            Text("Default (Name A-Z)").tag(ViewModel.SortOption.defaultSort)
                            Text("Price: Low to High").tag(ViewModel.SortOption.priceAscending)
                            Text("Price: High to Low").tag(ViewModel.SortOption.priceDescending)
                        }
                    } label: {
                        Label("Sort", systemImage: viewModel.sortOption == .defaultSort ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                    }
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

extension ProductCatalog {
    @Observable
    class ViewModel: Failable {
        let repository: any RepositoryProtocol<Product>
        
        enum SortOption: String, CaseIterable {
            case defaultSort = "Default"
            case priceAscending = "Price: Low to High"
            case priceDescending = "Price: High to Low"
            
            var label: String { self.rawValue }
        }
        
        init(repository: any RepositoryProtocol<Product>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        var products: [Product] = []
        var filter: String = ""
        var sortOption: SortOption = .defaultSort
        
        var isFiltered: Bool {
            !filter.isEmpty || sortOption != .defaultSort
        }
        
        var filteredProducts: [Product] {
            var matches = filter.isEmpty ? products : products.filter {
                $0.name.localizedCaseInsensitiveContains(filter) ||
                $0.productNumber.localizedCaseInsensitiveContains(filter)
            }
            
            switch sortOption {
            case .defaultSort:
                return matches.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            case .priceAscending:
                return matches.sorted { $0.listPrice < $1.listPrice }
            case .priceDescending:
                return matches.sorted { $0.listPrice > $1.listPrice }
            }
        }
        
        func clearCriteria() {
            filter = ""
            sortOption = .defaultSort
        }
        
        func loadProducts() async {
            do { products = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}