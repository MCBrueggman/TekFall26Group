//
//  InventoryAwarenessView.swift
//  BootcampCapstone
//

import SwiftUI

struct InventoryAwarenessView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<InventoryItem>) {
        _viewModel = State(initialValue: ViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Controls Section
                VStack(spacing: 12) {
                    Toggle("Show Reorder Alert Stock Only", isOn: $viewModel.showReorderOnly)
                        .font(.body)
                        .frame(minHeight: 44)
                        .accessibilityHint("Filters list to show only items at or below reorder threshold")
                    
                    Picker("Location Filter", selection: $viewModel.selectedLocation) {
                        Text("All Locations").tag("")
                        ForEach(viewModel.availableLocations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                // Inventory List
                List(viewModel.filteredInventory) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(item.productName)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            if item.isAtOrBelowReorderPoint {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text("REORDER")
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
                        
                        Divider()
                        
                        // Consolidated product, location, shelf/bin, and threshold details
                        ViewThatFits(in: .horizontal) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Location: \(item.locationName)")
                                        .font(.subheadline)
                                    Text("Shelf: \(item.shelf)  •  Bin: \(item.bin)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Qty: \(item.quantity)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundStyle(item.isAtOrBelowReorderPoint ? .red : .primary)
                                    Text("Threshold: \(item.reorderPoint)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Location: \(item.locationName)")
                                    .font(.subheadline)
                                Text("Shelf: \(item.shelf)  •  Bin: \(item.bin)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Qty: \(item.quantity) (Threshold: \(item.reorderPoint))")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(item.isAtOrBelowReorderPoint ? .red : .primary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(item.productName), Location: \(item.locationName), Shelf \(item.shelf), Bin \(item.bin). Current Quantity: \(item.quantity), Reorder threshold: \(item.reorderPoint). \(item.isAtOrBelowReorderPoint ? "Warning: Stock is at or below reorder threshold." : "")")
                }
            }
            .navigationTitle("Inventory Awareness")
            .searchable(text: $viewModel.searchQuery, prompt: "Search product, shelf, or bin")
            .task {
                await viewModel.loadInventory()
            }
        }
    }
}

extension InventoryAwarenessView {
    @Observable
    class ViewModel: Failable {
        let repository: any RepositoryProtocol<InventoryItem>
        
        init(repository: any RepositoryProtocol<InventoryItem>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        var items: [InventoryItem] = []
        var searchQuery: String = ""
        var showReorderOnly: Bool = false
        var selectedLocation: String = ""
        
        var availableLocations: [String] {
            Array(Set(items.map { $0.locationName })).sorted()
        }
        
        var filteredInventory: [InventoryItem] {
            items.filter { item in
                let matchesSearch = searchQuery.isEmpty ||
                    item.productName.localizedCaseInsensitiveContains(searchQuery) ||
                    item.shelf.localizedCaseInsensitiveContains(searchQuery) ||
                    "\(item.bin)".contains(searchQuery)
                
                let matchesReorder = !showReorderOnly || item.isAtOrBelowReorderPoint
                let matchesLocation = selectedLocation.isEmpty || item.locationName == selectedLocation
                
                return matchesSearch && matchesReorder && matchesLocation
            }
        }
        
        func loadInventory() async {
            do {
                items = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}