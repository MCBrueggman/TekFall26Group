//
//  EmployeeList.swift
//  BootcampCapstone
//  Created by Solomon Chambers on 9/21/26.
//  Modified by Shawn Defibaugh
//

import SwiftUI

enum SortingEmployees: String, CaseIterable, Identifiable {
    case idLowToHigh = "ID: Low to High"
    case idHighToLow = "ID: High to Low"
    case firstNameZA = "First Name (Z-A)"
    case firstNameAZ = "First Name (A-Z)"
    case lastNameZA = "Last Name (Z-A)"
    case lastNameAZ = "Last Name (A-Z)"
    
    var id: Self { self }
}

struct EmployeeList: View {
    @State var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<Employee>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - View Mode Picker (Adequate Touch Target & Scalable)
                Picker("View Mode", selection: $viewModel.inGroups) {
                    Text("Departments").tag(true)
                    Text("Employees").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .accessibilityLabel("Employee view mode selector")
                .accessibilityHint("Switches between grouped department view and flat employee list")
                
                // MARK: - Employee List
                List {
                    if viewModel.inGroups {
                        ForEach(viewModel.groupedEmployees, id: \.title) { group in
                            DisclosureGroup(group.title) {
                                ForEach(group.employees) { employee in
                                    EmployeeRow(employee: employee)
                                }
                            }
                            .accessibilityLabel("Department: \(group.title), \(group.employees.count) employees")
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
            .searchable(text: $viewModel.filter, prompt: "Search name, title, or ID")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sorting) {
                            ForEach(SortingEmployees.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title3)
                            .frame(width: 44, height: 44) // Guaranteed 44x44pt touch target
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Sort options")
                    .accessibilityHint("Select sorting order for employee list")
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

// MARK: - Accessible Employee Row
struct EmployeeRow: View {
    let employee: Employee
    
    var body: some View {
        NavigationLink(value: employee) {
            ViewThatFits(in: .horizontal) {
                // Standard Horizontal Layout
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(employee.firstName) \(employee.lastName)")
                            .font(.headline)
                        Text(employee.jobTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("ID: \(employee.id)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                
                // Dynamic Type Reflow Layout (Vertical Stack for Large Text Settings)
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(employee.firstName) \(employee.lastName)")
                        .font(.headline)
                    Text(employee.jobTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("ID: \(employee.id)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .padding(.vertical, 4)
        }
        .frame(minHeight: 44) // 44pt minimum touch target
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(employee.firstName) \(employee.lastName), Job Title: \(employee.jobTitle), Employee ID: \(employee.id)")
        .accessibilityHint("Double tap to open employee details")
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
        var employees: [Employee] = [] {
            didSet {
                filter = ""
            }
        }
        
        var filter: String = "" {
            didSet {
                matchingEmployee = employees.filter { employee in
                    filter.isEmpty
                    || employee.jobTitle.localizedCaseInsensitiveContains(filter)
                    || employee.firstName.localizedCaseInsensitiveContains(filter)
                    || employee.lastName.localizedCaseInsensitiveContains(filter)
                    || String(employee.id).contains(filter)
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
        
        var selectedEmployee: Employee? = nil
        var sorting: SortingEmployees = .lastNameAZ
        var inGroups: Bool = true
        
        private func sortedList(_ list: [Employee]) -> [Employee] {
            switch sorting {
            case .lastNameZA:
                return list.sorted { $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedDescending }
            case .firstNameZA:
                return list.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedDescending }
            case .lastNameAZ:
                return list.sorted { $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending }
            case .firstNameAZ:
                return list.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending }
            case .idLowToHigh:
                return list.sorted { $0.id < $1.id }
            case .idHighToLow:
                return list.sorted { $0.id > $1.id }
            }
        }
        
        var groupedEmployees: [(title: String, employees: [Employee])] {
            Dictionary(grouping: matchingEmployee) { $0.department ?? "Unspecified" }
                .map { (title: $0.key, employees: sortedList($0.value)) }
                .sorted { $0.title < $1.title }
        }
        
        var sortedEmployees: [Employee] {
            sortedList(matchingEmployee)
        }
        
        func loadEmployees() async {
            do { employees = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}