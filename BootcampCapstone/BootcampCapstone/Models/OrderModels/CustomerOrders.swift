//
//  CustomerOrders.swift
//  BootcampCapstone
//
//  Created by Solomon Chamebrs on 10/11/26.
//

import Foundation

@Observable
class CustomerOrder: Identifiable, Hashable, Codable {
    var id: Int
    var customerId:             Int
    var firstName:              String
    var middleName:             String?
    var lastName:               String
    var suffix:                 String?
    var phoneNumber:            String?
    var phoneNumberType:        String?
    var emailAddress:           String?
    var orderNumber:            Int
    var orderDate:              Date?
    var shipDate:               Date?
    //var freight:                Int
    //var freightNumber:          Int
    var shipMethodName:         String?
    var taxAmt:                 Double?
    var productId:              Int?
    var productName:            String
    var carrierTrackingNumber:  String?
    var orderQty:               Int
    var unitPrice:              Double
    var unitPriceDiscount:      Double?
    var lineTotal:              Double

    enum CodingKeys: String, CodingKey {
        case id, customerId, firstName, middleName, lastName, suffix
        case phoneNumber, phoneNumberType, emailAddress
        case orderNumber, orderDate, shipDate
        case /*freight, freightNumber,*/ shipMethodName, taxAmt
        case productId, productName, carrierTrackingNumber
        case orderQty, unitPrice, unitPriceDiscount, lineTotal
    }

    init(id: Int, customerId: Int, firstName: String, middleName: String? = nil,
         lastName: String, suffix: String? = nil, phoneNumber: String? = nil,
         phoneNumberType: String? = nil, emailAddress: String? = nil,
         orderNumber: Int, orderDate: Date? = nil, shipDate: Date? = nil,
         /*freight: Int = 0, freightNumber: Int = 0,*/ shipMethodName: String? = nil,
         taxAmt: Double? = 0, productId: Int?, productName: String,
         carrierTrackingNumber: String? = nil, orderQty: Int, unitPrice: Double,
         unitPriceDiscount: Double? = 0, lineTotal: Double) {
        self.id                    = id
        self.customerId            = customerId
        self.firstName             = firstName
        self.middleName            = middleName
        self.lastName              = lastName
        self.suffix                = suffix
        self.phoneNumber           = phoneNumber
        self.phoneNumberType       = phoneNumberType
        self.emailAddress          = emailAddress
        self.orderNumber           = orderNumber
        self.orderDate             = orderDate
        self.shipDate              = shipDate
        //self.freight               = freight
        //self.freightNumber         = freightNumber
        self.shipMethodName        = shipMethodName
        self.taxAmt                = taxAmt
        self.productId             = productId
        self.productName           = productName
        self.carrierTrackingNumber = carrierTrackingNumber
        self.orderQty              = orderQty
        self.unitPrice             = unitPrice
        self.unitPriceDiscount     = unitPriceDiscount
        self.lineTotal             = lineTotal
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id                    = try c.decode(Int.self, forKey: .id)
        customerId            = try c.decode(Int.self, forKey: .customerId)
        firstName             = try c.decode(String.self, forKey: .firstName)
        middleName            = try c.decodeIfPresent(String.self, forKey: .middleName)
        lastName              = try c.decode(String.self, forKey: .lastName)
        suffix                = try c.decodeIfPresent(String.self, forKey: .suffix)
        phoneNumber           = try c.decodeIfPresent(String.self, forKey: .phoneNumber)
        phoneNumberType       = try c.decodeIfPresent(String.self, forKey: .phoneNumberType)
        emailAddress          = try c.decodeIfPresent(String.self, forKey: .emailAddress)
        orderNumber           = try c.decode(Int.self, forKey: .orderNumber)
        orderDate             = try c.decodeIfPresent(Date.self, forKey: .orderDate)
        shipDate              = try c.decodeIfPresent(Date.self, forKey: .shipDate)
        //freight               = try c.decode(Int.self, forKey: .freight)
        //freightNumber         = try c.decode(Int.self, forKey: .freightNumber)
        shipMethodName        = try c.decodeIfPresent(String.self, forKey: .shipMethodName)
        taxAmt                = try c.decodeIfPresent(Double.self, forKey: .taxAmt)
        productId             = try c.decodeIfPresent(Int.self, forKey: .productId)
        productName           = try c.decode(String.self, forKey: .productName)
        carrierTrackingNumber = try c.decodeIfPresent(String.self, forKey: .carrierTrackingNumber)
        orderQty              = try c.decode(Int.self, forKey: .orderQty)
        unitPrice             = try c.decode(Double.self, forKey: .unitPrice)
        unitPriceDiscount     = try c.decodeIfPresent(Double.self, forKey: .unitPriceDiscount)
        lineTotal             = try c.decode(Double.self, forKey: .lineTotal)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(customerId, forKey: .customerId)
        try c.encode(firstName, forKey: .firstName)
        try c.encodeIfPresent(middleName, forKey: .middleName)
        try c.encode(lastName, forKey: .lastName)
        try c.encodeIfPresent(suffix, forKey: .suffix)
        try c.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try c.encodeIfPresent(phoneNumberType, forKey: .phoneNumberType)
        try c.encodeIfPresent(emailAddress, forKey: .emailAddress)
        try c.encode(orderNumber, forKey: .orderNumber)
        try c.encodeIfPresent(orderDate, forKey: .orderDate)
        try c.encodeIfPresent(shipDate, forKey: .shipDate)
        //try c.encode(freight, forKey: .freight)
        //try c.encode(freightNumber, forKey: .freightNumber)
        try c.encodeIfPresent(shipMethodName, forKey: .shipMethodName)
        try c.encodeIfPresent(taxAmt, forKey: .taxAmt)
        try c.encodeIfPresent(productId, forKey: .productId)
        try c.encode(productName, forKey: .productName)
        try c.encodeIfPresent(carrierTrackingNumber, forKey: .carrierTrackingNumber)
        try c.encode(orderQty, forKey: .orderQty)
        try c.encode(unitPrice, forKey: .unitPrice)
        try c.encodeIfPresent(unitPriceDiscount, forKey: .unitPriceDiscount)
        try c.encode(lineTotal, forKey: .lineTotal)
    }

    static func == (lhs: CustomerOrder, rhs: CustomerOrder) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
