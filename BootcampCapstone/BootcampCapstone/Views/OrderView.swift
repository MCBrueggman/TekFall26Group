//
//  OrderView.swift
//  BootcampCapstone
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
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header Info & View Switcher
                VStack(spacing: 8) {
                    Text("Active Orders")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Showing \(viewModel.groupedOrders.count) orders • Total: \(viewModel.grandTotal.formatted(.currency(code: "USD")))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel("\(viewModel.groupedOrders.count) total orders active, worth \(viewModel.grandTotal.formatted(.currency(code: "USD")))")
                    
                    Picker("Order View Mode", selection: $viewModel.showingAllOrders) {
                        Text("All Orders").tag(true)
                        Text("Grouped by Date").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 4)
                    .accessibilityLabel("Order view mode switcher")
                    .accessibilityHint("Switches between a flat list of all active orders and orders grouped by date")
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                // MARK: - Order List
                List {
                    if viewModel.showingAllOrders {
                        ForEach(viewModel.sortedOrders) { order in
                            OrderRow(order: order)
                        }
                    } else {
                        ForEach(viewModel.ordersByDate) { group in
                            DisclosureGroup {
                                ForEach(group.orders) { order in
                                    OrderRow(order: order)
                                }
                            } label: {
                                ViewThatFits(in: .horizontal) {
                                    HStack(alignment: .firstTextBaseline) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(group.title)
                                                .font(.headline)
                                            Text("\(group.count) orders")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text(group.total.formatted(.currency(code: "USD")))
                                            .font(.body)
                                            .bold()
                                            .monospacedDigit()
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(group.title)
                                            .font(.headline)
                                        Text("\(group.count) orders")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text(group.total.formatted(.currency(code: "USD")))
                                            .font(.body)
                                            .bold()
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .accessibilityLabel("Date group: \(group.title), \(group.count) orders, Group total: \(group.total.formatted(.currency(code: "USD")))")
                        }
                    }
                }
                .animation(.default, value: viewModel.showingAllOrders)
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.filter, prompt: "Search order # or customer name")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sortOption) {
                            ForEach(SortingOrders.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                            .frame(width: 44, height: 44) // Guaranteed 44x44pt touch target
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Sort options")
                    .accessibilityHint("Select sorting criteria for active orders")
                }
            }
            .navigationDestination(for: GroupedOrder.self) { order in
                OrderOverview(order: order, repository: viewModel.repository, productRepo: productRepo)
            }
        }
        .task {
            await viewModel.loadOrders()
        }
    }
}

// MARK: - Accessible Order Row
struct OrderRow: View {
    let order: GroupedOrder
    
    var body: some View {
        NavigationLink(value: order) {
            ViewThatFits(in: .horizontal) {
                // Standard Horizontal Layout
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Order #\(order.orderNumber)")
                            .font(.headline)
                        Text("\(order.firstName) \(order.lastName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(order.total.formatted(.currency(code: "USD")))
                        .font(.body)
                        .bold()
                        .monospacedDigit()
                }
                
                // Dynamic Type Reflow Layout (Vertical Stack for Accessibility Text Sizes)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.headline)
                    Text("\(order.firstName) \(order.lastName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(order.total.formatted(.currency(code: "USD")))
                        .font(.body)
                        .bold()
                }
            }
            .padding(.vertical, 4)
        }
        .frame(minHeight: 44) // 44pt minimum touch target height
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Order number \(order.orderNumber), Customer: \(order.firstName) \(order.lastName), Total amount: \(order.total.formatted(.currency(code: "USD")))")
        .accessibilityHint("Double tap to open complete order summary")
    }
}

extension OrderView {
    @Observable
    class ViewModel: Failable {
        let repository: any RepositoryProtocol<CustomerOrder>
        init(repository: any RepositoryProtocol<CustomerOrder>) { self.repository = repository }
        var errorMessage: String = ""
        
        var orders: [CustomerOrder] = [] {
            didSet { filter = "" }
        }
        
        var filter: String = "" {
            didSet {
                matchingOrder = orders.filter { order in
                    filter.isEmpty
                    || String(order.orderNumber).contains(filter)
                    || order.firstName.localizedCaseInsensitiveContains(filter)
                    || order.lastName.localizedCaseInsensitiveContains(filter)
                }
            }
        }
        
        var matchingOrder: [CustomerOrder] = [] {
            didSet {
                if let selected = selectedEmployee,
                   !matchingOrder.contains(selected) {
                    selectedEmployee = nil
                }
            }
        }
        
        var selectedEmployee: CustomerOrder? = nil
        var showingAllOrders: Bool = true
        var sortOption: SortingOrders = .newestToOldest
        
        var groupedOrders: [GroupedOrder] {
            Dictionary(grouping: matchingOrder, by: \.orderNumber)
                .map { GroupedOrder(orderNumber: $0.key, grouping: $0.value) }
                .sorted { $0.orderNumber < $1.orderNumber }
        }
        
        private func sortedList(_ list: [GroupedOrder]) -> [GroupedOrder] {
            switch sortOption {
            case .newestToOldest:
                return list.sorted {
                    let orderA = $0.orderDate ?? .distantPast
                    let orderB = $1.orderDate ?? .distantPast
                    if orderA != orderB { return orderA > orderB }
                    return $0.orderNumber > $1.orderNumber
                }
            case .oldestToNewest:
                return list.sorted {
                    let orderA = $0.orderDate ?? .distantPast
                    let orderB = $1.orderDate ?? .distantPast
                    if orderA != orderB { return orderA < orderB }
                    return $0.orderNumber < $1.orderNumber
                }
            case .highestToLowest:
                return list.sorted {
                    if $0.total != $1.total { return $0.total > $1.total }
                    return $0.orderNumber > $1.orderNumber
                }
            case .lowestToHighest:
                return list.sorted {
                    if $0.total != $1.total { return $0.total < $1.total }
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
            do { orders = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}