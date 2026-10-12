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
            List(viewModel.lowStock) { product in
                    VStack(alignment: .leading) {
                        Text(product.productName)
                            .font(.headline)
                        
                        Text("Stock: \(product.stockLevel)")
                        
                        Text("Reorder Point: \(product.reorderPoint)")
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
            }
            catch {
                errorMessage = "\(error)"
            }
        }
    }
}
