//
//  ShiftHistory.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import Foundation

struct ShiftHistory: Codable, Identifiable, Hashable {
    
    var id: Int { shiftId }
    let employeeId: Int
    let departmentId: Int
    let departmentName: String
    let departmentGroup: String
    let shiftId: Int
    let shiftName: String
    let startDate: Date
    let endDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case employeeId, departmentId, departmentName, departmentGroup
        case shiftId, shiftName, startDate, endDate
    }
}
