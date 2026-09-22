//
//  EnvironmentalExtensions.swift
//  BootcampCapstone
//
//  Created by user301385 on 9/21/26.
//

import SwiftUI

extension EnvironmentValues {
    
    var employeeRepository: any RepositoryProtocol<Employee> {
        get { self[EmployeeRepositoryKey.self] }
        set { self[EmployeeRepositoryKey.self] = newValue }
    }
    
}
