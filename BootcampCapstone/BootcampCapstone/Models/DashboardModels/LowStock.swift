//
//  LowStock.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class LowStock: Codable, Identifiable {
    let id: Int
    let productName: String
    let stockLevel: Int
    let reorderPoint: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productName, stockLevel, reorderPoint
    }
    init(id: Int, productName: String, stockLevel: Int, reorderPoint: Int){
        self.id = id
        self.productName = productName
        self.stockLevel = stockLevel
        self.reorderPoint = reorderPoint
    }
}
