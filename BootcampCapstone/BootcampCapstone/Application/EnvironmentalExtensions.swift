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
    var weeklySalesRepository: any RepositoryProtocol<WeeklySales> {
        get { self[WeeklySalesRepositoryKey.self] }
        set { self[WeeklySalesRepositoryKey.self] = newValue }
    }
        
    var bestWorstRepository: any RepositoryProtocol<BestWorstProducts> {
        get { self[BestWorstRepositoryKey.self] }
        set { self[BestWorstRepositoryKey.self] = newValue }
    }
        
    var lowStockRepository: any RepositoryProtocol<LowStock> {
        get { self[LowStockRepositoryKey.self] }
        set { self[LowStockRepositoryKey.self] = newValue }
    }
        
    var dashboardShiftRepository: any RepositoryProtocol<DasboardShift> {
        get { self[DashboardShiftRepositoryKey.self] }
        set { self[DashboardShiftRepositoryKey.self] = newValue }
    }
}
