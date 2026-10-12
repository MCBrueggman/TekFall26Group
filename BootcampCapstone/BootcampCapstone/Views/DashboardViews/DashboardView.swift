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
            VStack(spacing: 20) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .bold()
                NavigationLink(destination: WeeklySalesDetailsView(repository: weeklySalesRepository)) {
                        VStack {
                            Text("Weekly Sales")
                                .font(.headline)
                            WeeklySalesSummaryView(
                                repository: weeklySalesRepository
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }
                NavigationLink(destination: BestWorstDetailsView(repository: bestWorstRepository)) {
                        VStack {
                            Text("Best & Worst Products")
                                .font(.headline)
                            BestWorstSummaryView(
                                repository: bestWorstRepository
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }
                NavigationLink(destination: LowStockDetailsView(repository: lowStockRepository)) {
                        VStack {
                            Text("Low Stock")
                                .font(.headline)
                            LowStockSummaryView(
                                repository: lowStockRepository
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    }
                NavigationLink(destination: DashboardShiftDetailsView(repository: dashboardShiftRepository)) {
                        VStack {
                            Text("Employee Shifts")
                                .font(.headline)
                            DashboardShiftSummaryView(
                                repository: dashboardShiftRepository
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }
            }.padding(20)
        }
    }
}


