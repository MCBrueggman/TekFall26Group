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
        VStack {
            if !viewModel.errorMessage.isEmpty {
                Text("Unable to load data. Check your internet connection.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    if let best = viewModel.bestProduct {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Best Selling")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(best.productName)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text("\(best.unitsSold) sold")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize()
                        }
                    }
                    
                    if let worst = viewModel.worstProduct {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Worst Selling")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(worst.productName)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text("\(worst.unitsSold) sold")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize()
                        }
                    }
                }
            }
        }
        .task {
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
                errorMessage = ""
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}
