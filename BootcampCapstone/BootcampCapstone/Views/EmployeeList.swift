//
//  EmployeeList.swift
//  BootcampCapstone
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
            VStack(spacing: 0) {
                // MARK: - Active Criteria Bar
                if viewModel.isFiltered {
                    HStack {
                        Text("Active Criteria:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if !viewModel.selectedDepartment.isEmpty {
                            Text("Dept: \(viewModel.selectedDepartment)")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.12))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Button("Clear All") {
                            viewModel.clearCriteria()
                        }
                        .font(.caption)
                        .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.secondarySystemBackground))
                }
                
                // MARK: - Employee Grouped List
                List {
                    ForEach(viewModel.groupedEmployees, id: \.title) { group in
                        Section(header: Text(group.title)) {
                            ForEach(group.employees) { employee in
                                NavigationLink(value: employee) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("\(employee.firstName) \(employee.lastName)")
                                                .font(.body)
                                            Text(employee.jobTitle)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Employees")
            .searchable(text: $viewModel.filter, prompt: "Search name or title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("All Departments") {
                            viewModel.selectedDepartment = ""
                        }
                        Divider()
                        ForEach(viewModel.availableDepartments, id: \.self) { dept in
                            Button(dept) {
                                viewModel.selectedDepartment = dept
                            }
                        }
                    } label: {
                        Label("Department", systemImage: viewModel.selectedDepartment.isEmpty ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
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
        
        var errorMessage: String = ""
        var employees: [Employee] = []
        var filter: String = ""
        var selectedDepartment: String = ""
        
        var isFiltered: Bool {
            !filter.isEmpty || !selectedDepartment.isEmpty
        }
        
        var availableDepartments: [String] {
            Array(Set(employees.compactMap { $0.department })).sorted()
        }
        
        var matchingEmployee: [Employee] {
            employees.filter { employee in
                let matchesSearch = filter.isEmpty ||
                    employee.firstName.localizedCaseInsensitiveContains(filter) ||
                    employee.lastName.localizedCaseInsensitiveContains(filter) ||
                    employee.jobTitle.localizedCaseInsensitiveContains(filter)
                
                let matchesDept = selectedDepartment.isEmpty || employee.department == selectedDepartment
                
                return matchesSearch && matchesDept
            }
        }
        
        var groupedEmployees: [(title: String, employees: [Employee])] {
            let grouped = Dictionary(grouping: matchingEmployee) { $0.department ?? "Unspecified" }
            return grouped
                .map { (title: $0.key, employees: $0.value.sorted {
                    $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending
                }) }
                .sorted { $0.title < $1.title }
        }
        
        func clearCriteria() {
            filter = ""
            selectedDepartment = ""
        }
        
        func loadEmployees() async {
            do { employees = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}