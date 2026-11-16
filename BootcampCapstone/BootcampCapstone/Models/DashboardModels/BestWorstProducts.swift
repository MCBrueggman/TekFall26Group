//
//  BestWorstProducts.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class BestWorstProducts: Codable, Identifiable {
    let id: Int
    let productName: String
    let unitsSold: Int
    let unitsInStock: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productName, unitsSold, unitsInStock
    }
    init(id: Int, productName: String, unitsSold: Int, unitsInStock: Int){
        self.id = id
        self.productName = productName
        self.unitsSold = unitsSold
        self.unitsInStock = unitsInStock
    }
}
