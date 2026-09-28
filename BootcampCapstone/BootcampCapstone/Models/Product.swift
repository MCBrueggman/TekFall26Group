//
//  Product.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 9/27/26.
//

import SwiftUI

@Observable
class Product: Identifiable, Hashable, Codable {
    
    var id: Int
    var name: String
    var productNumber: String
    var summary: String?
    var thumbnailPhoto: String?
    var thumbnailPhotoFileName: String?
    var warranty: String?
    var color: String?
    var listPrice: Double

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name, productNumber, summary, thumbnailPhoto, thumbnailPhotoFileName, warranty, color, listPrice
    }
    
    init(id: Int, name: String, productNumber: String, summary: String? = nil,
         thumbnailPhoto: String? = nil, thumbnailPhotoFileName: String? = nil,
         warranty: String? = nil, color: String? = nil, listPrice: Double) {
        self.id = id
        self.name = name
        self.productNumber = productNumber
        self.summary = summary
        self.thumbnailPhoto = thumbnailPhoto
        self.thumbnailPhotoFileName = thumbnailPhotoFileName
        self.warranty = warranty
        self.color = color
        self.listPrice = listPrice
    }
    
    required init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        productNumber = try container.decode(String.self, forKey: .productNumber)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        thumbnailPhoto = try container.decodeIfPresent(String.self, forKey: .thumbnailPhoto)
        thumbnailPhotoFileName = try container.decodeIfPresent(String.self, forKey: .thumbnailPhotoFileName)
        warranty = try container.decodeIfPresent(String.self, forKey: .warranty)
        color = try container.decodeIfPresent(String.self, forKey: .color)
        listPrice = try container.decode(Double.self, forKey: .listPrice)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(productNumber, forKey: .productNumber)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encodeIfPresent(thumbnailPhoto, forKey: .thumbnailPhoto)
        try container.encodeIfPresent(thumbnailPhotoFileName, forKey: .thumbnailPhotoFileName)
        try container.encodeIfPresent(warranty, forKey: .warranty)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encode(listPrice, forKey: .listPrice)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
