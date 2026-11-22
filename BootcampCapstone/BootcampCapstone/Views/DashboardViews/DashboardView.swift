//
//  DashboardView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/7/26.
//


import SwiftUI

struct DashboardView: View {
    let weeklySalesRepository: any RepositoryProtocol<WeeklySales>
    let bestWorstRepository: any RepositoryProtocol<BestWorstProducts>
    let lowStockRepository: any RepositoryProtocol<LowStock>
    let dashboardShiftRepository: any RepositoryProtocol<DasboardShift>

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    WeeklySalesDetailsView(repository: weeklySalesRepository)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weekly Sales")
                            .font(.headline)

                        WeeklySalesSummaryView(
                            repository: weeklySalesRepository
                        )
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink {
                    BestWorstDetailsView(repository: bestWorstRepository)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Best & Worst Products")
                            .font(.headline)

                        BestWorstSummaryView(
                            repository: bestWorstRepository
                        )
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink {
                    LowStockDetailsView(repository: lowStockRepository)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Low Stock")
                            .font(.headline)

                        LowStockSummaryView(
                            repository: lowStockRepository
                        )
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink {
                    DashboardShiftDetailsView(
                        repository: dashboardShiftRepository
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Employee Shifts")
                            .font(.headline)

                        DashboardShiftSummaryView(
                            repository: dashboardShiftRepository
                        )
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}



