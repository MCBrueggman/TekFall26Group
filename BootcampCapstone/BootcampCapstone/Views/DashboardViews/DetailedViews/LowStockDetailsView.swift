//
//  LowStockDetailsView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//

import SwiftUI

struct LowStockDetailsView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<LowStock>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack {
            Text("Low Stock Products")
                .font(.largeTitle)
                .bold()

            if !viewModel.errorMessage.isEmpty {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)

                    Text("Failed to load.")
                        .font(.headline)

                    Text("The Internet connection appears to be offline.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Try again") {
                        Task {
                            await viewModel.loadLowStock()
                        }
                    }
                }
                .padding()

                Spacer()

            } else {
                List(viewModel.lowStock) { product in
                    VStack(alignment: .leading) {
                        Text(product.productName)
                            .font(.headline)

                        Text("Stock: \(product.stockLevel)")

                        Text("Reorder Point: \(product.reorderPoint)")
                    }
                }
            }
        }
        .task {
            await viewModel.loadLowStock()
        }
    }
}

extension LowStockDetailsView {
    @Observable class ViewModel: Failable{
        private let repository: any RepositoryProtocol<LowStock>
        init(repository: any RepositoryProtocol<LowStock>){
            self.repository = repository
        }
        var errorMessage: String = ""
        var lowStock: [LowStock] = []
        func loadLowStock() async {
            do {
                lowStock = try await repository.getAll()
                errorMessage = ""
            }
            catch {
                errorMessage = "\(error)"
            }
        }
    }
}
