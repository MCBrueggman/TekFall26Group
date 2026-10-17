//
//  LowStockDetailsView.swift
//  BootcampCapstone
//  Created by user301407 on 10/9/26.
//

import SwiftUI

struct LowStockDetailsView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<LowStock>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Accessible Header Controls
            VStack(spacing: 12) {
                Toggle(isOn: $viewModel.showCriticalOnly) {
                    Text("Critical Low Stock Only")
                        .font(.body)
                }
                .minimumScaleFactor(0.8)
                .frame(minHeight: 44) // Accessible touch target
                .accessibilityHint("Filters the list to show only items below reorder thresholds")
                
                Picker("Sort By", selection: $viewModel.sortOption) {
                    Text("Urgency").tag(ViewModel.SortOption.stockAscending)
                    Text("Product Name").tag(ViewModel.SortOption.name)
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Sort order for low stock items")
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            
            // MARK: - Active Filter Indicator
            if viewModel.isFiltered {
                HStack {
                    Label("Active Filters", systemImage: "line.3.horizontal.decrease.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button(action: { viewModel.resetCriteria() }) {
                        Text("Reset Filters")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.red)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                    }
                    .frame(minWidth: 44, minHeight: 44) // Target size check
                    .accessibilityLabel("Reset all stock filters")
                }
                .padding(.horizontal)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
            }
            
            // MARK: - Accessible Items List
            List(viewModel.displayedLowStock) { product in
                let isCritical = product.stockLevel <= product.reorderPoint
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(product.productName)
                            .font(.headline)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        // Non-color dependent alert indicator (Text + Icon + Color)
                        if isCritical {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("CRITICAL")
                            }
                            .font(.caption2)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.15))
                            .foregroundStyle(.red)
                            .clipShape(Capsule())
                        }
                    }
                    
                    ViewThatFits {
                        HStack {
                            Text("Stock: \(product.stockLevel)")
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(isCritical ? .red : .primary)
                            
                            Spacer()
                            
                            Text("Reorder Point: \(product.reorderPoint)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Stock: \(product.stockLevel)")
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(isCritical ? .red : .primary)
                            Text("Reorder Point: \(product.reorderPoint)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 4)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(product.productName), Current stock: \(product.stockLevel), Reorder point: \(product.reorderPoint). \(isCritical ? "Warning: Critical stock level, reorder needed." : "")")
            }
        }
        .navigationTitle("Low Stock Details")
        .task {
            await viewModel.loadLowStock()
        }
    }
}

extension LowStockDetailsView {
    @Observable class ViewModel: Failable {
        private let repository: any RepositoryProtocol<LowStock>
        
        enum SortOption {
            case stockAscending
            case name
        }
        
        init(repository: any RepositoryProtocol<LowStock>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        var lowStock: [LowStock] = []
        
        var showCriticalOnly: Bool = false
        var sortOption: SortOption = .stockAscending
        
        var isFiltered: Bool {
            showCriticalOnly || sortOption != .stockAscending
        }
        
        var displayedLowStock: [LowStock] {
            var items = lowStock
            if showCriticalOnly {
                items = items.filter { $0.stockLevel <= $0.reorderPoint }
            }
            
            switch sortOption {
            case .stockAscending:
                items.sort { $0.stockLevel < $1.stockLevel }
            case .name:
                items.sort { $0.productName.localizedCaseInsensitiveCompare($1.productName) == .orderedAscending }
            }
            return items
        }
        
        func resetCriteria() {
            showCriticalOnly = false
            sortOption = .stockAscending
        }
        
        func loadLowStock() async {
            do {
                lowStock = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}