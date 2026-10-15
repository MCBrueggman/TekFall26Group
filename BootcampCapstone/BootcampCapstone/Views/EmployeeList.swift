//
//  LoginView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import SwiftUI

struct EmployeeList: View {
    
    @State var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<Employee>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Department View", isOn: $viewModel.inGroups)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.top, 8)
                List {
                    if viewModel.inGroups {
                        ForEach(viewModel.groupedEmployees, id: \.title) { group in
                            DisclosureGroup(group.title) {
                                ForEach(group.employees) { employee in
                                    EmployeeRow(employee: employee)
                                }
                            }
                        }
                    } else {
                        ForEach(viewModel.sortedEmployees) { employee in
                            EmployeeRow(employee: employee)
                        }
                    }
                }
                .animation(.default, value: viewModel.inGroups)
            }
            .navigationTitle("Employees")
            .searchable(text: $viewModel.filter)
            .navigationDestination(for: Employee.self) { employee in
                EmployeeDetailView(employee: employee, repository: viewModel.repository)
            }
        }
        .task {
            await viewModel.loadEmployees()
        }
    }
}

extension EmployeeList {
    @Observable
    class ViewModel: Failable {
        
        let repository: any RepositoryProtocol<Employee>
        init(repository: any RepositoryProtocol<Employee>) {
            self.repository = repository
        }
        private let counter: Double = 0
        var errorMessage: String = ""
        
        var employees: [Employee] = [] {
            didSet {
                filter = ""
            }
        }
        var filter: String   = "" {
            didSet {
                matchingEmployee = employees.filter { employee in
                    filter == "" || (employee.jobTitle.lowercased()
                        .contains(filter.lowercased()))
                }
            }
        }
        var matchingEmployee: [Employee] = [] {
            didSet {
                if let selected = selectedEmployee,
                   !matchingEmployee.contains(selected) {
                    selectedEmployee = nil
                }
            }
        }
        var selectedEmployee: Employee?  = nil
        
        var groupedEmployees: [(title: String, employees: [Employee])] {
            let grouped = Dictionary(grouping: matchingEmployee) { $0.department ?? "Unspecified" }
            return grouped
                .map { (title: $0.key, employees: $0.value.sorted {
                    $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending
                }) }
                .sorted { $0.title < $1.title }
        }
        
        var inGroups: Bool = true
        
        var sortedEmployees: [Employee] {
            matchingEmployee.sorted {
                $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending
            }
        }
        
        func loadEmployees() async {
            do    { employees = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
            
        }
    }
}

struct EmployeeRow: View {
    let employee: Employee
    
    var body: some View {
        HStack {
            Text("\(employee.firstName) \(employee.lastName)")
        }
    }
}

//#Preview {
//    ArtistList()
//}
