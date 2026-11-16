//
//  RemoteLowStockRepo.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class RemoteLowStockRepo: RemoteRepositoryBase<LowStock>, RepositoryProtocol<LowStock> {

    private let urlBase: String

    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }

    func getAll() async throws -> [LowStock] {
        let urlString = "\(urlBase)/Dashboard/low-stock"
        return try await fetchAll(urlString)
    }

    func getById(_ id: Int) async throws -> LowStock? {
        return nil
    }

    func insert(_ item: LowStock) async throws -> LowStock {
        throw URLError(.unsupportedURL)
    }

    func update(_ item: LowStock) async throws {
        throw URLError(.unsupportedURL)
    }

    func delete(_ item: LowStock) async throws {
        throw URLError(.unsupportedURL)
    }

}
