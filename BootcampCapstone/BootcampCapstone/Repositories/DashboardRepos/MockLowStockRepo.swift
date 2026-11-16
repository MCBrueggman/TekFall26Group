//
//  MockLowStockRepo.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//


import Foundationclass MockLowStockRepo: RepositoryProtocol<LowStock> {        func getAll() async throws -> [LowStock] {        return [            LowStock(                id: 1,                productName: "Product A",                stockLevel: 3,                reorderPoint: 20            ),            LowStock(                id: 2,                productName: "Product B",                stockLevel: 5,                reorderPoint: 15            ),            LowStock(                id: 3,                productName: "Product C",                stockLevel: 7,                reorderPoint: 10            ),            LowStock(                id: 4,                productName: "Product D",                stockLevel: 9,                reorderPoint: 20            )        ]    }        func getById(_ id: Int) async throws -> LowStock? {        return nil    }        func insert(_ item: LowStock) async throws -> LowStock {        throw URLError(.unsupportedURL)    }        func update(_ item: LowStock) async throws {        throw URLError(.unsupportedURL)    }        func delete(_ item: LowStock) async throws {        throw URLError(.unsupportedURL)    }}