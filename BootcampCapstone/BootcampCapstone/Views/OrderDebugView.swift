//
//  OrderDebugView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/12/26.
//

import SwiftUI

struct OrderDebugView: View {
    let order: GroupedOrder

    private func row<T>(_ label: String, _ value: T?) -> some View {
        Text(verbatim: "\(label): \(value.map { "\($0)" } ?? "nil")")
    }

    var body: some View {
        List {
            Section("Order") {
                row("orderNumber", order.orderNumber)
                row("lines.count", order.grouping.count)
                row("orderDate", order.orderDate)
                row("shipDate", order.shipDate)
                row("shipMethodName", order.shipMethodName)
                row("carrierTrackingNumber", order.carrierTrackingNumber)
                row("taxAmt", order.taxAmt)
                row("subtotal", order.subtotal)
                row("total", order.total)
            }

            Section("Customer") {
                row("customerId", order.customerId)
                row("firstName", order.firstName)
                row("lastName", order.lastName)
                row("emailAddress", order.emailAddress)
                row("phoneNumber", order.phoneNumber)
            }

            ForEach(Array(order.grouping.enumerated()), id: \.offset) { index, line in
                Section("Line \(index + 1)") {
                    row("id", line.id)
                    row("productId", line.productId)
                    row("productName", line.productName)
                    row("orderQty", line.orderQty)
                    row("unitPrice", line.unitPrice)
                    row("unitPriceDiscount", line.unitPriceDiscount)
                    row("lineTotal", line.lineTotal)
                    row("middleName", line.middleName)
                    row("suffix", line.suffix)
                    row("phoneNumberType", line.phoneNumberType)
                }
            }
        }
        .navigationTitle("#\(order.orderNumber)")
    }
}
