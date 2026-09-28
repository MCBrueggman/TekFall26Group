//
//  MockProductRepo.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

class MockProductRepo: RepositoryProtocol<Product> {

    private var products = [
        Product(id: 1, name: "", productNumber: "",
                summary: "", color: "", listPrice: 9.99)
    ]

    func getAll() async throws -> [Product] {
        products
    }

    func getById(_ id: Int) async throws -> Product? {
        products.first(where: { $0.id == id })
    }

    func insert(_ item: Product) async throws -> Product {
        throw FeatureError.notImplemented
    }

    func update(_ item: Product) async throws {
        throw FeatureError.notImplemented
    }

    func delete(_ item: Product) async throws {
        throw FeatureError.notImplemented
    }
}
