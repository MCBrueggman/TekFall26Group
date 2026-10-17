//
//  DashboardView.swift
//  BootcampCapstone
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
            ScrollView {
                VStack(spacing: 16) {
                    // Weekly Sales
                    NavigationLink(destination: WeeklySalesDetailsView(repository: weeklySalesRepository)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Weekly Sales Overview")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            WeeklySalesSummaryView(repository: weeklySalesRepository)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                    .accessibilityLabel("Weekly Sales Summary")
                    .accessibilityHint("Double tap to open detailed weekly sales report")
                    
                    // Low Stock Alert Card
                    NavigationLink(destination: LowStockDetailsView(repository: lowStockRepository)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Label("Low Stock Alerts", systemImage: "exclamationmark.triangle.fill")
                                    .font(.headline)
                                    .foregroundStyle(.orange)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            LowStockSummaryView(repository: lowStockRepository)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                    .accessibilityLabel("Low Stock Overview")
                    .accessibilityHint("Double tap to open detailed low stock inventory report")
                    
                    // Product Performance Card
                    NavigationLink(destination: BestWorstDetailsView(repository: bestWorstRepository)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Best & Worst Products")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            BestWorstSummaryView(repository: bestWorstRepository)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                    .accessibilityLabel("Best and Worst Product Performance Summary")
                    .accessibilityHint("Double tap to open product performance details")
                    
                    // Employee Shift Summary Card
                    NavigationLink(destination: DashboardShiftDetailsView(repository: dashboardShiftRepository)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Employee Shifts")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            DashboardShiftSummaryView(repository: dashboardShiftRepository)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                    .accessibilityLabel("Employee Shift Roster Summary")
                    .accessibilityHint("Double tap to open detailed employee shift roster")
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}