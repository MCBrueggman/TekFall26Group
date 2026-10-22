//
//  OrderOverview.swift
//  BootcampCapstone
//  Created by Solomon Chambers on 10/11/26.
//  Modified by Mike Brueggman
//

import SwiftUI

struct OrderOverview: View {
    let order: GroupedOrder
    let repository: any RepositoryProtocol<CustomerOrder>
    let productRepo: any RepositoryProtocol<Product>
    
    @State private var orderDetails: CustomerOrder?
    @State private var products: [Product] = []
    @State private var errorMessage: String = ""
    
    var body: some View {
        List {
            // MARK: - Customer Information
            Section("Customer Information") {
                ViewThatFits(in: .horizontal) {
                    LabeledContent("Name:", value: "\(order.firstName) \(order.lastName)")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(order.firstName) \(order.lastName)")
                            .font(.body)
                            .bold()
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Customer Name: \(order.firstName) \(order.lastName)")
                
                ViewThatFits(in: .horizontal) {
                    LabeledContent("Customer ID:", value: String(order.customerId))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Customer ID:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(String(order.customerId))
                            .font(.body)
                            .monospacedDigit()
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Customer ID: \(order.customerId)")
            }
            
            // MARK: - Order Summary
            Section("Order Information") {
                LabeledContent("Order Number:", value: "#\(order.orderNumber)")
                    .accessibilityLabel("Order Number: \(order.orderNumber)")
                
                LabeledContent("Order Date:", value: order.orderDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                    .accessibilityLabel("Order Date: \(order.orderDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not available")")
                
                LabeledContent("Ship Date:", value: order.shipDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not shipped")
                    .accessibilityLabel("Ship Date: \(order.shipDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not shipped yet")")
                
                LabeledContent("Item Quantity:", value: String(order.grouping.count))
                    .accessibilityLabel("Item Quantity: \(order.grouping.count) items")
                
                ViewThatFits(in: .horizontal) {
                    LabeledContent("Total:", value: order.total.formatted(.currency(code: "USD")))
                        .bold()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total:")
                            .font(.headline)
                        Text(order.total.formatted(.currency(code: "USD")))
                            .font(.title3)
                            .bold()
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Order Total: \(order.total.formatted(.currency(code: "USD")))")
            }
            
            // MARK: - Line Items / Products
            Section("Products (\(order.grouping.count))") {
                ForEach(order.grouping) { item in
                    if let product = product(for: item) {
                        NavigationLink {
                            ProductDetailView(product: product, repository: productRepo)
                        } label: {
                            ProductLineItemRow(item: item)
                        }
                        .frame(minHeight: 44) // Guaranteed 44pt minimum touch target
                        .accessibilityHint("Double tap to view full product catalog entry")
                    } else {
                        ProductLineItemRow(item: item)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Order #\(order.orderNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                products = try await productRepo.getAll()
            } catch {
                errorMessage = "\(error)"
                print(errorMessage)
            }
        }
    }
    
    private var productsById: [Int: Product] {
        Dictionary(products.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
    }
    
    private func product(for line: CustomerOrder) -> Product? {
        if let id = line.productId, let match = productsById[id] { return match }
        return products.first { $0.name == line.productName }
    }
}

// MARK: - Accessible Product Line Row
struct ProductLineItemRow: View {
    let item: CustomerOrder
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            // Standard Horizontal Layout
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.productName)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Qty: \(item.orderQty)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(item.unitPrice.formatted(.currency(code: "USD")))
                    .font(.body)
                    .bold()
                    .monospacedDigit()
            }
            
            // Dynamic Type Reflow Layout (Large Text Settings)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.body)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("Qty: \(item.orderQty)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(item.unitPrice.formatted(.currency(code: "USD")))
                        .font(.body)
                        .bold()
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.productName), Quantity: \(item.orderQty), Price: \(item.unitPrice.formatted(.currency(code: "USD")))")
    }
}