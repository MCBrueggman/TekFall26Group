//
//  OrderView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/11/26.
//

import SwiftUI

struct OrderView: View {

    @State var viewModel: ViewModel
    let productRepo: any RepositoryProtocol<Product>
    
    init(repository: any RepositoryProtocol<CustomerOrder>, productRepo: any RepositoryProtocol<Product>) {
        viewModel = ViewModel(repository: repository)
        self.productRepo = productRepo
    }
    
    var body: some View {
        VStack {
            Text("Active Orders")
                .font(.largeTitle)
                .bold()
            Text("Showing \(viewModel.groupedOrders.count) orders · \(viewModel.grandTotal.formatted(.currency(code: "USD")))")
            NavigationStack {
                List {
                    ForEach(viewModel.ordersByDate) { group in
                        DisclosureGroup{
                            ForEach(group.orders) { order in
                                NavigationLink(value: order) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(verbatim: "Order #\(order.orderNumber)")
                                                .font(.headline)
                                            Text("\(order.firstName) \(order.lastName)")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text(order.total.formatted(.currency(code: "USD")))
                                            .monospacedDigit()
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(group.title)
                                    Text("\(group.count) orders")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(group.total.formatted(.currency(code: "USD")))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .navigationDestination(for: GroupedOrder.self) { order in
                    OrderOverview(order: order, repository: viewModel.repository, productRepo: productRepo)
                //.navigationDestination(for: GroupedOrder.self) { order in
                //    OrderDebugView(order: order)
                }
                .searchable(text: $viewModel.filter)
            }
            .task {
                await viewModel.loadOrders()
            }
        }
    }
}

extension OrderView {
    @Observable
    class ViewModel: Failable {

        let repository: any RepositoryProtocol<CustomerOrder>
        init(repository: any RepositoryProtocol<CustomerOrder>) { self.repository = repository }
        private let counter: Double = 0
        var errorMessage: String = ""
        
        var orders: [CustomerOrder] = [] {
            didSet {
                filter = ""
            }
        }
        var filter: String   = "" {
            didSet {
                matchingOrder = orders.filter { order in
                    filter.isEmpty
                    || String(order.orderNumber).contains(filter)                 // Filter by Order Number
                    || order.firstName.localizedCaseInsensitiveContains(filter)   // Filter by First Name
                    || order.lastName.localizedCaseInsensitiveContains(filter)    // Filter by Last Name
                }
            }
        }
        var matchingOrder: [CustomerOrder] = [] {
            didSet {
                if let selected = selectedOrder,
                   !matchingOrder.contains(selected) {
                    selectedOrder = nil
                }
            }
        }
        var selectedOrder: CustomerOrder?  = nil
        
        var groupedOrders: [GroupedOrder] {
            Dictionary(grouping: matchingOrder, by: \.orderNumber)
                .map { GroupedOrder(orderNumber: $0.key, grouping: $0.value) }
                .sorted { $0.orderNumber < $1.orderNumber }
        }
        
        var ordersByDate: [GroupedOrdersByDate] {
            Dictionary(grouping: groupedOrders) { order in
                order.orderDate.map { utcCalendar.startOfDay(for: $0) }
            }
            .map { GroupedOrdersByDate(date: $0.key, orders: $0.value) }
            .sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
        }
        
        private var utcCalendar: Calendar {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            return calendar
        }
        
        var grandTotal: Double {
            ordersByDate.reduce(0) { $0 + $1.total }
        }
        
        func loadOrders() async {
            do    { orders = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}
