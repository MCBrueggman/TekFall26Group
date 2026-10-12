//
//  WeeklySalesDetailsView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//

import SwiftUI

struct WeeklySalesDetailsView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<WeeklySales>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack {
            Text("Weekly Sales")
                .font(.largeTitle)
                .bold()
            
            List(viewModel.weeklySales) { week in
                VStack(alignment: .leading) {
                    Text(week.salesDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                    
                    Text("Sales: $\(week.totalSales, specifier: "%.2f")")
                    
                    Text("Profit: $\(week.totalProfit, specifier: "%.2f")")
                }
            }
        }
        .task {
            await viewModel.loadWeeklySales()
        }
    }
}

extension WeeklySalesDetailsView {
    @Observable
    class ViewModel: Failable {
        private let repository: any RepositoryProtocol<WeeklySales>
        
        init(repository: any RepositoryProtocol<WeeklySales>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        
        var weeklySales: [WeeklySales] = []
        
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
