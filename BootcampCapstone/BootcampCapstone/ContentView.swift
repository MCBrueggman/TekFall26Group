//
//  ContentView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

enum ListType: String, CaseIterable {
    case employees = "Employees"
    case dashboard = "Dashboard"
}

struct ContentView: View {
    @State private var current: String = ""

    @Environment(\.employeeRepository) private var employeeRepository
    @Environment(\.weeklySalesRepository) private var weeklySalesRepository
    @Environment(\.bestWorstRepository) private var bestWorstRepository
    @Environment(\.lowStockRepository) private var lowStockRepository
    @Environment(\.dashboardShiftRepository) private var dashboardShiftRepository
    @EnvironmentObject var authStatus: AuthStatus
   
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "employees": EmployeeList(repository: employeeRepository)
                case "dashboard": DashboardView(weeklySalesRepository: weeklySalesRepository,
                                        bestWorstRepository: bestWorstRepository,
                                        lowStockRepository: lowStockRepository,
                                        dashboardShiftRepository: dashboardShiftRepository
                )
                    default: HomeView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Employee Info") { current = "employees"}
                        Divider()
                        Button("Dasboard") { current = "dashboard"}
                        Divider()
                        Button("Logout") { authStatus.updateLoginStatus(success: false)}
                    }
                    label: {
                        Label("View", systemImage: "line.3.horizontal")
                    }
                }
            }
        }
    }
}
