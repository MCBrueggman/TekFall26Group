//
//  InventoryItem.swift
//  BootcampCapstone
//

import Foundation

struct InventoryItem: Identifiable, Codable, Hashable {
    let id: Int
    let productId: Int
    let productName: String
    let locationName: String
    let shelf: String
    let bin: Int
    let quantity: Int
    let reorderPoint: Int
    
    var isAtOrBelowReorderPoint: Bool {
        quantity <= reorderPoint
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "inventoryId"
        case productId, productName, locationName, shelf, bin, quantity, reorderPoint
    }
}