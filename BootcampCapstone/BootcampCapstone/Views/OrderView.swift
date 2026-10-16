//
//  OrderView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/11/26.
//  Modified by Shawn Defibaugh
//

import SwiftUI

enum SortingOrders: String, CaseIterable, Identifiable {
    case highestToLowest = "Price: High to Low"
    case lowestToHighest = "Price: Low to High"
    case oldestToNewest = "Date: Oldest to Newest"
    case newestToOldest = "Date: Newest to Oldest"
    
    var id: Self { self }
}

struct OrderView: View {
    
    @State var viewModel: ViewModel
    let productRepo: any RepositoryProtocol<Product>
    
    init(repository: any RepositoryProtocol<CustomerOrder>, productRepo: any RepositoryProtocol<Product>) {
        viewModel = ViewModel(repository: repository)
        self.productRepo = productRepo
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                Text("Active Orders")
                    .font(.largeTitle)
                    .bold()
                
                Text("Showing \(viewModel.groupedOrders.count) orders · \(viewModel.grandTotal.formatted(.currency(code: "USD")))")
                
                VStack {
                    Picker("View", selection: $viewModel.showingAllOrders) {
                        Text("All Orders").tag(true)
                        Text("Dates").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    List {
                        if viewModel.showingAllOrders {
                            ForEach(viewModel.sortedOrders) { order in
                                OrderRow(order: order)
                            }
                        }
                        
                        else {
                            ForEach(viewModel.ordersByDate) { group in
                                DisclosureGroup {
                                    ForEach(group.orders) { order in
                                        OrderRow(order: order)
                                    }
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(group.title)
                                                .font(.title3)
                                                .bold()
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
                    }
                }
                
                .animation(.default, value: viewModel.showingAllOrders)
                .navigationDestination(for: GroupedOrder.self) { order in
                    OrderOverview(order: order, repository: viewModel.repository, productRepo: productRepo)
                }
                .searchable(text: $viewModel.filter)
                .toolbar {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(.fixed, placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        Menu {
                            Picker("Sort by", selection: $viewModel.sortOption) {
                                ForEach(SortingOrders.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
            .task {
                await viewModel.loadOrders()
            }
        }
    }
}

struct OrderRow: View {
    let order: GroupedOrder
    
    var body: some View {
        NavigationLink(value: order) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: "Order #\(order.orderNumber)")
                        .font(.headline)
                    Text("\(order.firstName) \(order.lastName)")
                        .font(.subheadline)
                }
                Spacer()
                Text(order.total.formatted(.currency(code: "USD")))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

extension OrderView {
    @Observable
    class ViewModel: Failable {
        
        let repository: any RepositoryProtocol<CustomerOrder>
        init(repository: any RepositoryProtocol<CustomerOrder>) { self.repository = repository }
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
        
        var showingAllOrders: Bool = true
        var sortOption: SortingOrders = .newestToOldest
        
        private func sortedList(_ list: [GroupedOrder]) -> [GroupedOrder] {
            switch sortOption {
            case .newestToOldest:
                return list.sorted {
                    let orderA = $0.orderDate ?? .distantPast
                    let orderB = $1.orderDate ?? .distantPast
                    if orderA != orderB {
                        return orderA > orderB
                    }
                    return $0.orderNumber > $1.orderNumber
                }
            case .oldestToNewest:
                return list.sorted {
                    let orderA = $0.orderDate ?? .distantPast
                    let orderB = $1.orderDate ?? .distantPast
                    if orderA != orderB {
                        return orderA < orderB
                    }
                    return $0.orderNumber < $1.orderNumber
                }
            case .highestToLowest:
                return list.sorted {
                    if $0.total != $1.total {
                        return $0.total > $1.total
                    }
                    return $0.orderNumber > $1.orderNumber
                }
            case .lowestToHighest:
                return list.sorted {
                    if $0.total != $1.total {
                        return $0.total < $1.total
                    }
                    return $0.orderNumber < $1.orderNumber
                }
            }
        }
        
        var sortedOrders: [GroupedOrder] {
            sortedList(groupedOrders)
        }
        
        var ordersByDate: [GroupedOrdersByDate] {
            let groups = Dictionary(grouping: groupedOrders) { order in
                order.orderDate.map { utcCalendar.startOfDay(for: $0) }
            }
                .map { GroupedOrdersByDate(date: $0.key, orders: sortedList($0.value)) }
            
            switch sortOption {
            case .newestToOldest:
                return groups.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
            case .oldestToNewest:
                return groups.sorted { ($0.date ?? .distantPast) < ($1.date ?? .distantPast) }
            case .highestToLowest:
                return groups.sorted { $0.total > $1.total }
            case .lowestToHighest:
                return groups.sorted { $0.total < $1.total }
            }
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
