//
//  EmployeeDetailView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import SwiftUI

struct EmployeeDetailView: View {
    let employee: Employee
    let repository: any RepositoryProtocol<Employee>
    
    @State private var employmentDetails: Employee?
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Text(("\(employee.firstName) \(employee.lastName)"))
                .font(.largeTitle)
                .bold()
            List {
                LabeledContent("Employee ID:", value: "\(employee.id)")
                if let department = employee.department {
                    LabeledContent("Department:", value: department)
                }
                if let title = employee.title {
                    LabeledContent("Title:", value: title).padding(20)
                }
                LabeledContent("Job Title:", value: employee.jobTitle)
                if let shift = employee.shift {
                    LabeledContent("Shift:", value: shift)
                }
                if let hireDate = employee.hireDate {
                    LabeledContent("Hire Date:", value: hireDate.formatted(date: .abbreviated, time: .omitted))
                }
                Section("Job History") {
                    if let employmentDetails {
                        if (employmentDetails.shiftHistory ?? []) .isEmpty {
                            Text("No Other Job History")
                                .foregroundStyle(.secondary)
                        } else if ((employmentDetails.shiftHistory ?? []) .count == 1) {
                            Text("No Other Job History")
                        } else {
                            ForEach(employmentDetails.shiftHistory ?? []) { entry in
                                VStack(alignment: .leading) {
                                    Text("\(entry.id)")
                                    Text(entry.departmentName)
                                        .font(.headline)
                                    Text(entry.departmentGroup)
                                    Text("\(entry.shiftName) Shift")
                                    Text("\(entry.startDate.formatted(date: .abbreviated, time: .omitted)) – \(entry.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Present")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            do    { employmentDetails = try await repository.getById(employee.id) }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}
