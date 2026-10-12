//
//  WeeklySalesSummaryView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/7/26.
//

import SwiftUI

struct WeeklySalesSummaryView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<WeeklySales>){
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack{
            if let week = viewModel.latestWeek {
                            Text("$\(week.totalSales, specifier: "%.2f")")
                                .font(.title2)
                                .bold()
                            
                            Text("Profit: $\(week.totalProfit, specifier: "%.2f")")
                                .font(.subheadline)
                        }
        }.task{
            await viewModel.loadWeeklySales()
        }
    }
}
extension WeeklySalesSummaryView {
    @Observable class ViewModel: Failable{
        private let repository: any RepositoryProtocol<WeeklySales>
        init(repository: any RepositoryProtocol<WeeklySales>){
            self.repository = repository
        }
        var errorMessage: String = ""
        var weeklySales: [WeeklySales] = []
        var latestWeek: WeeklySales? {
                    weeklySales.max { $0.salesDate < $1.salesDate }
                }
        func loadWeeklySales() async {
            do {
                weeklySales = try await repository.getAll()
            }
            catch {
                errorMessage = "\(error)"
            }
        }
    }
}

