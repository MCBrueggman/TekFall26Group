//
//  LoginView.swift
//  BootcampCapstone
//
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
            VStack {
                Picker("View", selection: $viewModel.inGroups) {
                    Text("Departments").tag(true)
                    Text("Employees").tag(false)
                }
                .pickerStyle(.segmented)
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
                    }
                    
                    else {
                        ForEach(viewModel.sortedEmployees) { employee in
                            EmployeeRow(employee: employee)
                        }
                    }
                }
                .animation(.default, value: viewModel.inGroups)
            }
            .navigationTitle("Employees")
            .searchable(text: $viewModel.filter)
            .toolbar {
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
                ToolbarSpacer(.fixed, placement: .bottomBar)
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Picker("Sort by", selection: $viewModel.sorting) {
                            ForEach(SortingEmployees.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
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
        
        var selectedEmployee: Employee?  = nil
        
        var sorting: SortingEmployees = .lastNameAZ
        
        private func sortedList(_ list: [Employee]) -> [Employee] {
            switch sorting {
            case .lastNameZA:
                return list.sorted {
                    $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedDescending
                }
            case .firstNameZA:
                return list.sorted {
                    $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedDescending
                }
            case .lastNameAZ:
                return list.sorted {
                    $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending
                }
            case .firstNameAZ:
                return list.sorted {
                    $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending
                }
            case .idLowToHigh:
                return list.sorted {
                    $0.id < $1.id
                }
            case .idHighToLow:
                return list.sorted {
                    $0.id > $1.id
                }
            }
        }
        
        var groupedEmployees: [(title: String, employees: [Employee])] {
            Dictionary(grouping: matchingEmployee) { $0.department ?? "Unspecified" }
                .map { (title: $0.key, employees: sortedList($0.value)) }
                .sorted { $0.title < $1.title }
        }
        
        var inGroups: Bool = true
        
        var sortedEmployees: [Employee] {
            sortedList(matchingEmployee)
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
        NavigationLink(value: employee) {
            HStack {
                Text("\(employee.firstName) \(employee.lastName)")
                Spacer()
                Text("ID: \(employee.id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//#Preview {
//    ArtistList()
//}
