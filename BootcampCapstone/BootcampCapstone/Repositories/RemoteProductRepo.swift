//
//  RemoteProductRepo.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

import Foundation

class RemoteProductRepo: RemoteRepositoryBase<Product>, RepositoryProtocol<Product> {
    
    private let urlBase: String
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
   
    func getAll() async throws -> [Product] {
        let urlString = "\(urlBase)/Product"
        return try await fetchAll(urlString)
    }
    
    func getById(_ id: Int) async throws -> Product? {
        let urlString = "\(urlBase)/Product/\(id)"
        return try await fetchOne(urlString)
    }
    
    func insert(_ item: Product) async throws -> Product {
        let urlString = "\(urlBase)/Product/"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: Product) async throws {
        let urlString = "\(urlBase)/Product/\(item.id)"
        try await put(urlString, send: item)
    }
    
    func delete(_ item: Product) async throws {
        let urlString = "\(urlBase)/Product/\(item.id)"
        try await del(urlString)
    }
    
}
