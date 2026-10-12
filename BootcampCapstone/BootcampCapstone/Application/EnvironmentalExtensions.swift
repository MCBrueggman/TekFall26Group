//
//  EnvironmentalExtensions.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import SwiftUI

extension EnvironmentValues {
    
    var employeeRepository: any RepositoryProtocol<Employee> {
        get { self[EmployeeRepositoryKey.self] }
        set { self[EmployeeRepositoryKey.self] = newValue }
    }
    
    var productRepository: any RepositoryProtocol<Product> {
        get { self[ProductRepositoryKey.self] }
        set { self[ProductRepositoryKey.self] = newValue }
    }
    
    var orderRepository: any RepositoryProtocol<CustomerOrder> {
        get { self[OrderRepositoryKey.self] }
        set { self[OrderRepositoryKey.self] = newValue }
    }
    
}
