//
//  GroupedOrdersByDate.swift
//  BootcampCapstone
//
//  Created by user301385 on 10/12/26.
//

import Foundation

struct GroupedOrdersByDate: Identifiable {
    let date: Date?
    let orders: [GroupedOrder]

    var id: Date { date ?? .distantPast }

    var title: String {
        guard let date else { return "No date" }
        let utc = TimeZone(secondsFromGMT: 0)!
        return date.formatted(Date.FormatStyle(date: .abbreviated, time: .omitted, timeZone: utc))
    }
    
    var count: Int { orders.count }
    var total: Double { orders.reduce(0) { $0 + $1.total } }
}
