//
//  RepositoryInjectionKeys.swift
//  BootcampCapstone
//
//  Created by user301385 on 9/21/26.
//

import SwiftUI

struct EmployeeRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<Employee> = MockEmployeeRepo()
}

