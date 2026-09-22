//
//  RepositoryProtocol.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

protocol RepositoryProtocol<Item> {

    associatedtype Item: Identifiable, Codable

    func getAll() async throws -> [Item]
    func getById(_ id: Item.ID) async throws -> Item?
    func insert(_ item: Item) async throws -> Item
    func update(_ item: Item) async throws
    func delete(_ item: Item) async throws

}

