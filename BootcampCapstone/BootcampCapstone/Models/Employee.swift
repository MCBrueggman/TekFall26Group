//
//  Employee.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import SwiftUI

@Observable
class Employee: Identifiable, Hashable, Codable {
    
    var id: Int
    var firstName:  String
    var middleName: String?
    var lastName:   String
    var suffix:     String?
    var title:      String?
    var jobTitle:   String
    var shift:      String?
    var department: String?
    var hireDate:   Date?
    var shiftHistory: [ShiftHistory]? = []

    enum CodingKeys: String, CodingKey {
        case id = "employeeId"
        case firstName, lastName, title, jobTitle, shift, department, hireDate, shiftHistory
    }
    
    init(id: Int, firstName: String, middleName: String? = nil, lastName: String,
         suffix: String? = nil, title: String, jobTitle: String,
    shift: String? = nil, department: String? = nil, hireDate: Date? = nil, shiftHistory: [ShiftHistory]? = nil) {
        self.id = id
        self.firstName      = firstName
        self.middleName     = middleName
        self.lastName       = lastName
        self.suffix         = suffix
        self.title          = title
        self.jobTitle       = jobTitle
        self.shift          = shift
        self.department     = department
        self.hireDate       = hireDate
        self.shiftHistory   = shiftHistory
    }
    
    required init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        id              = try container.decode(Int.self, forKey: .id)
        firstName       = try container.decode(String.self, forKey: .firstName)
        lastName        = try container.decode(String.self, forKey: .lastName)
        title           = try container.decodeIfPresent(String.self, forKey: .title)
        jobTitle        = try container.decode(String.self, forKey: .jobTitle)
        shift           = try container.decodeIfPresent(String.self, forKey: .shift)
        department      = try container.decodeIfPresent(String.self, forKey: .department)
        hireDate        = try container.decodeIfPresent(Date.self, forKey: .hireDate)
        shiftHistory    = try container.decodeIfPresent([ShiftHistory].self, forKey: .shiftHistory) ?? []
        middleName      = nil
        suffix          = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encode(jobTitle, forKey: .jobTitle)
        try container.encodeIfPresent(shift, forKey: .shift)
        try container.encodeIfPresent(department, forKey: .department)
        try container.encodeIfPresent(hireDate, forKey: .hireDate)
        try container.encodeIfPresent(shiftHistory, forKey: .shiftHistory)
    }
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
