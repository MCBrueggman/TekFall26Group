//
//  OrderOverview.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/11/26.
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
        List{
            Section("Customer Information:") {
                LabeledContent("Name:", value: "\(order.firstName) \(order.lastName)")
                LabeledContent("Customer Id:", value: String(order.customerId))
            }
            Section("Order Information:") {
                LabeledContent("Order Number:", value: String(order.orderNumber))
                LabeledContent("Order Date:", value: order.orderDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                LabeledContent("Ship Date:", value: order.shipDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not shipped")
                LabeledContent("Item Quantity:", value: String(order.grouping.count))
                LabeledContent("Total:", value: order.total.formatted(.currency(code: "USD")))
               }
            Section("Products") {
                ForEach(order.grouping) { item in
                    let lab = LabeledContent("\(item.productName)", value: item.unitPrice.formatted(.currency(code: "USD")))
                    if let product = product(for: item) {
                        NavigationLink {
                            ProductDetailView(product: product, repository: productRepo)
                        } label: { lab }
                    } else { lab }
                }
            }
        }.task {
            do { products = try await productRepo.getAll() }
            catch { errorMessage = "\(error)"; print(errorMessage) }
        }
    }
    
    // allows you to go to that items view from this screen by comparing the ids
    private var productsById: [Int: Product] {
        Dictionary(products.map { ($0.id, $0) },
            uniquingKeysWith: { first, _ in first })
    }
    private func product(for line: CustomerOrder) -> Product? {
        if let id = line.productId, let match = productsById[id] { return match }
        return products.first { $0.name == line.productName }
    }
    
}
