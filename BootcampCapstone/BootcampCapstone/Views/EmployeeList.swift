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
                List {
                    ForEach(viewModel.groupedEmployees, id: \.title) { group in
                        Section(header: Text(group.title)) {
                            ForEach(group.employees) { employee in
                                NavigationLink(value: employee) {
                                    HStack {
                                        Text("\(employee.firstName) \(employee.lastName)")
                                    }
                                }
                            }
                        }
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
        
        func loadEmployees() async {
            do    { employees = try await repository.getAll() }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
            
        }
    }
}

//#Preview {
//    ArtistList()
//}
