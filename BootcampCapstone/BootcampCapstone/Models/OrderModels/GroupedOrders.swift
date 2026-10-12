//
//  GroupedOrders.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/11/26.
//

import Foundation

struct GroupedOrder: Identifiable, Hashable {
    let orderNumber: Int
    let grouping: [CustomerOrder]

    var id: Int { orderNumber }

    // Customer info
    var firstName:              String { grouping[0].firstName }
    var lastName:               String { grouping[0].lastName }
    var customerId:             Int { grouping[0].customerId }
    var emailAddress:           String? { grouping[0].emailAddress }
    var phoneNumber:            String? { grouping[0].phoneNumber }

    // Order info
    var orderDate:              Date? { grouping[0].orderDate }
    var shipDate:               Date? { grouping[0].shipDate }
    var shipMethodName:         String? { grouping[0].shipMethodName }
    var carrierTrackingNumber:  String? { grouping[0].carrierTrackingNumber }
    //var freight:                Int { grouping[0].freight }
    var taxAmt:                 Double? { grouping[0].taxAmt }

    // totals
    var subtotal: Double { grouping.reduce(0) { $0 + $1.lineTotal } }
    var total: Double { subtotal + ( taxAmt ?? 0 ) }

    static func == (lhs: GroupedOrder, rhs: GroupedOrder) -> Bool {
        lhs.orderNumber == rhs.orderNumber
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(orderNumber)
    }
}
