//
//  ContentView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import SwiftUI

enum ListType: String, CaseIterable {
    case employees = "Employees"
}

struct ContentView: View {
    @State private var current: String = ""

    @Environment(\.employeeRepository) private var employeeRepository
    @EnvironmentObject var authStatus: AuthStatus
   
    var body: some View {
        NavigationStack {
            VStack {
                switch current {
                case "employees": EmployeeList(repository: employeeRepository)
                    default: HomeView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Employee Info") { current = "employees"}
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
