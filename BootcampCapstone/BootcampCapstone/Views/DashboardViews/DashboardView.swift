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
                    // MARK: - Hero Section: Weekly Sales
                    NavigationLink(destination: WeeklySalesDetailsView(repository: weeklySalesRepository)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Weekly Sales Overview", systemImage: "chart.line.uptrend.xyaxis")
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                            }
                            
                            WeeklySalesSummaryView(repository: weeklySalesRepository)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    // MARK: - Action Alert: Low Stock
                    NavigationLink(destination: LowStockDetailsView(repository: lowStockRepository)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Low Stock Alerts", systemImage: "exclamationmark.triangle.fill")
                                    .font(.headline)
                                    .foregroundStyle(.orange)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundStyle(.tertiary)
                            }
                            
                            LowStockSummaryView(repository: lowStockRepository)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    // MARK: - Secondary Metrics Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        // Product Performance Card
                        NavigationLink(destination: BestWorstDetailsView(repository: bestWorstRepository)) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Label("Products", systemImage: "arrow.up.arrow.down.square")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                Divider()
                                BestWorstSummaryView(repository: bestWorstRepository)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }

                        // Employee Shifts Card
                        NavigationLink(destination: DashboardShiftDetailsView(repository: dashboardShiftRepository)) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Label("Shifts", systemImage: "person.2.fill")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                Divider()
                                DashboardShiftSummaryView(repository: dashboardShiftRepository)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(maxHeight: .infinity, alignment: .topLeading)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Dashboard")
        }
    }
}