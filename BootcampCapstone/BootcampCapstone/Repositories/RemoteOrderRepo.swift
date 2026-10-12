//
//  RemoteOrderRepo.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/11/26.
//


import Foundation

class RemoteOrderRepo: RemoteRepositoryBase<CustomerOrder>, RepositoryProtocol<CustomerOrder> {
    
    private let urlBase: String
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
   
    func getAll() async throws -> [CustomerOrder] {
        let urlString = "\(urlBase)/Order/customer"
        return try await fetchAll(urlString)
    }
    
    func getById(_ id: Int) async throws -> CustomerOrder? {
        let urlString = "\(urlBase)/Order/cusomter/\(id)"
        return try await fetchOne(urlString)
    }
    
    func insert(_ item: CustomerOrder) async throws -> CustomerOrder {
        let urlString = "\(urlBase)/Order/customer/"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: CustomerOrder) async throws {
        let urlString = "\(urlBase)/Order/customer/\(item.id)"
        try await put(urlString, send: item)
    }
    
    func delete(_ item: CustomerOrder) async throws {
        let urlString = "\(urlBase)/Order/customer/\(item.id)"
        try await del(urlString)
    }
    
}
