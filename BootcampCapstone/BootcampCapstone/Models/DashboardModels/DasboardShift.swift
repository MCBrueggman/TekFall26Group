//
//  DasboardShift.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class DasboardShift: Codable, Identifiable {
    let id: Int
    let firstName: String
    let middleName: String?
    let lastName: String
    let suffix: String?
    let shift: String
    
    enum CodingKeys: String, CodingKey {
        case id = "employeeId"
        case firstName, middleName, lastName, suffix, shift
    }
    init(id: Int, firstName: String, middleName: String, lastName: String, suffix: String, shift: String) {
        self.id = id
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.suffix = suffix
        self.shift = shift
    }
}
