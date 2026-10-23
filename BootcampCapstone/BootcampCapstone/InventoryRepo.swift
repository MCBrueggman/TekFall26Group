//
//  InventoryRepo.swift
//  BootcampCapstone
//
//  Created by user301537 on 10/23/26.
//

//
//  InventoryRepo.swift
//  BootcampCapstone
//

import Foundation

class RemoteInventoryRepo: RemoteRepositoryBase<InventoryItem>, RepositoryProtocol<InventoryItem> {
    private let urlBase: String
    
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
    
    func getAll() async throws -> [InventoryItem] {
        let urlString = "\(urlBase)/Inventory"
        return try await fetchAll(urlString)
    }
    
    func getById(_ id: Int) async throws -> InventoryItem? {
        let urlString = "\(urlBase)/Inventory/\(id)"
        return try await fetchOne(urlString)
    }
    
    func insert(_ item: InventoryItem) async throws -> InventoryItem {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: InventoryItem) async throws {
        throw FeatureError.notImplemented
    }
    
    func delete(_ item: InventoryItem) async throws {
        throw FeatureError.notImplemented
    }
}
