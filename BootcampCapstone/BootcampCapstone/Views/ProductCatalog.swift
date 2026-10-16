//
//  ProductCatalog.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

import SwiftUI

enum SortingProducts: String, CaseIterable, Identifiable {
    case lowToHigh = "Price Low to High"
    case highToLow = "Price High to Low"
    case ztoa = "Z-A"
    case atoz = "A-Z"
    
    var id: Self { self }
}

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
            .toolbar {
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
                ToolbarSpacer(.fixed, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sorting) {
                            ForEach(SortingProducts.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
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
        init(repository: any RepositoryProtocol<Product>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        var products: [Product] = []
        var filter: String = ""
        var sorting: SortingProducts = .atoz
        
        private func sortedList(_ list: [Product]) -> [Product] {
            switch sorting {
            case .atoz:
                return list.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
            case .ztoa:
                return list.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
                }
            case .highToLow:
                return list.sorted { $0.listPrice > $1.listPrice }
            case .lowToHigh:
                return list.sorted { $0.listPrice < $1.listPrice }
            }
        }
        
        var filteredProducts: [Product] {
            let matches = filter.isEmpty ? products : products.filter {
                $0.name.localizedCaseInsensitiveContains(filter) ||
                $0.productNumber.localizedCaseInsensitiveContains(filter)
            }
            return sortedList(matches)
        }
        
        func loadProducts() async {
            do    { products = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}
