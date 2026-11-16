//
//  LowStockSummaryView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//

import SwiftUI

struct LowStockSummaryView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<LowStock>){
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack{
            ForEach(viewModel.urgentProducts) { product in
                HStack {
                    Text(product.productName)
                    Spacer()
                    Text("\(product.stockLevel) left")
                }
            }
        }
        .task {
            await viewModel.loadLowStock()
        }
    }
}
extension LowStockSummaryView {
    @Observable class ViewModel: Failable{
        private let repository: any RepositoryProtocol<LowStock>
        init(repository: any RepositoryProtocol<LowStock>){
            self.repository = repository
        }
        var errorMessage: String = ""
        var lowStock: [LowStock] = []
                
        var urgentProducts: [LowStock] {
            lowStock
                .sorted { $0.stockLevel < $1.stockLevel }
                .prefix(3)
                .map { $0 }
        }
                
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
