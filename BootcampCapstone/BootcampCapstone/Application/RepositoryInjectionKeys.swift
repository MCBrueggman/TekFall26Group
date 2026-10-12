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

struct WeeklySalesRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<WeeklySales> = MockWeeklySalesRepo()
}

struct BestWorstRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<BestWorstProducts> = MockBestWorstProductsRepo()
}

struct LowStockRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<LowStock> = MockLowStockRepo()
}

struct DashboardShiftRepositoryKey: EnvironmentKey {
    static let defaultValue: any RepositoryProtocol<DasboardShift> = MockDashboardShiftRepo()
}
