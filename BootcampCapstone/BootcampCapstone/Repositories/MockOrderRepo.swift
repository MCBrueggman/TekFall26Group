//
//  MockEmployeeRepo.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import Foundation

class MockOrderRepo: RepositoryProtocol<CustomerOrder> {
    
    private var orders = [
        CustomerOrder(id: 1, customerId: 101, firstName: "Solomon", lastName: "Chambers",
                      emailAddress: "Solomon.Chambers@example.com",
                      orderNumber: 11078, orderDate: .now, taxAmt: 8.25,
                      productId: 1001, productName: "Hitch Rack - 4-Bike",
                      orderQty: 1, unitPrice: 120.00, lineTotal: 120.00),

        CustomerOrder(id: 2, customerId: 102, firstName: "John", lastName: "Smith",
                      orderNumber: 11927, orderDate: .now, taxAmt: 3.10,
                      productId: 1002, productName: "AWC Logo Cap",
                      orderQty: 2, unitPrice: 8.99, lineTotal: 17.98),

        CustomerOrder(id: 3, customerId: 102, firstName: "John", lastName: "Smith",
                      orderNumber: 11927, orderDate: .now, taxAmt: 3.10,
                      productId: 1003, productName: "Bike Wash - Dissolver",
                      orderQty: 1, unitPrice: 7.95, lineTotal: 7.95),
    ]

    func getAll() async throws -> [CustomerOrder] {
        orders
    }
    
    func getById(_ id: Int) async throws -> CustomerOrder? {
        orders.first(where: { $0.id == id })
    }
    
    func insert(_ item: CustomerOrder) async throws -> CustomerOrder {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: CustomerOrder) async throws {
        throw FeatureError.notImplemented
    }
    
    func delete(_ item: CustomerOrder) async throws {
        throw FeatureError.notImplemented
    }
   
    
}
