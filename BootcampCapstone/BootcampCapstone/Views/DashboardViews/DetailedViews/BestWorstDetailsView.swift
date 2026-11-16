//
//  BestWorstDetailsView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//


import SwiftUI

struct BestWorstDetailsView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<BestWorstProducts>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack {
                Text("Best-Worst Products")
                    .font(.largeTitle)
                    .bold()
                    
                List(viewModel.bestWorst) { product in
                    VStack(alignment: .leading) {
                        Text(product.productName)
                            .font(.headline)
                        Text("Units Sold: \(product.unitsSold)")
                        Text("Units In Stock: \(product.unitsInStock)")
                    }
                }
            }
            .task {
                    await viewModel.loadProducts()
            }
            
    }
}

extension BestWorstDetailsView {
    @Observable
    class ViewModel: Failable {
        private let repository: any RepositoryProtocol<BestWorstProducts>
        
        init(repository: any RepositoryProtocol<BestWorstProducts>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        
        var bestWorst: [BestWorstProducts] = []
        
        func loadProducts() async {
            do {
                bestWorst = try await repository.getAll()
                }
            catch {
                errorMessage = "\(error)"
            }
        }
    }
}
