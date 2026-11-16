//
//  BestWorstSummaryView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/7/26.
//

import SwiftUI

struct BestWorstSummaryView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<BestWorstProducts>){
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack{
                if let best = viewModel.bestProduct {
                    Text("Best: \(best.productName)")
                        .font(.title2)
                        .bold()

                    Text("\(best.unitsSold) sold")
                        .font(.subheadline)
                }
                if let worst = viewModel.worstProduct {
                    Text("Worst: \(worst.productName)")
                        .font(.title2)
                        .bold()

                    Text("\(worst.unitsSold) sold")
                        .font(.subheadline)
                }
        }.task{
            await viewModel.loadProducts()
        }
    }
}
extension BestWorstSummaryView {
    @Observable class ViewModel: Failable{
        private let repository: any RepositoryProtocol<BestWorstProducts>
        init(repository: any RepositoryProtocol<BestWorstProducts>){
            self.repository = repository
        }
        var errorMessage: String = ""
        var bestWorst: [BestWorstProducts] = []
        var bestProduct: BestWorstProducts? {
                    bestWorst.max { $0.unitsSold < $1.unitsSold }
                }
                
        var worstProduct: BestWorstProducts? {
            bestWorst.min { $0.unitsSold < $1.unitsSold }
        }
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
