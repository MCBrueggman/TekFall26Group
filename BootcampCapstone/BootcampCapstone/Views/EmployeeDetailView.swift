//
//  EmployeeDetailView.swift
//  BootcampCapstone
//  Created by Solomon Chambers on 9/21/26.
//  Modified by Mike Brueggman
//

import SwiftUI

struct EmployeeDetailView: View {
    let employee: Employee
    let repository: any RepositoryProtocol<Employee>
    
    @State private var employmentDetails: Employee?
    @State private var errorMessage: String = ""
    
    var body: some View {
        List {
            // Header Section
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(employee.firstName) \(employee.lastName)")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(employee.jobTitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(employee.firstName) \(employee.lastName), Job Title: \(employee.jobTitle)")
            }
            
            // Employee Information
            Section("Details") {
                LabeledContent("Employee ID:", value: "\(employee.id)")
                    .accessibilityLabel("Employee ID: \(employee.id)")
                
                if let department = employee.department {
                    LabeledContent("Department:", value: department)
                        .accessibilityLabel("Department: \(department)")
                }
                
                if let title = employee.title, !title.isEmpty {
                    LabeledContent("Title:", value: title)
                        .accessibilityLabel("Title: \(title)")
                }
                
                if let shift = employee.shift {
                    LabeledContent("Shift:", value: shift)
                        .accessibilityLabel("Shift: \(shift)")
                }
                
                if let hireDate = employee.hireDate {
                    LabeledContent("Hire Date:", value: hireDate.formatted(date: .abbreviated, time: .omitted))
                        .accessibilityLabel("Hire Date: \(hireDate.formatted(date: .abbreviated, time: .omitted))")
                }
            }
            
            // Job History Section
            Section("Job History") {
                if let employmentDetails {
                    let history = employmentDetails.shiftHistory ?? []
                    if history.isEmpty || history.count <= 1 {
                        Text("No Other Job History")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(history) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.departmentName)
                                    .font(.headline)
                                Text("\(entry.departmentGroup) • \(entry.shiftName) Shift")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("\(entry.startDate.formatted(date: .abbreviated, time: .omitted)) – \(entry.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Present")")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 4)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Department: \(entry.departmentName), Group: \(entry.departmentGroup), Shift: \(entry.shiftName), From \(entry.startDate.formatted(date: .abbreviated, time: .omitted)) to \(entry.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Present")")
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView("Loading Job History...")
                        Spacer()
                    }
                    .frame(minHeight: 44)
                }
            }
        }
        .navigationTitle("Employee Overview")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do { employmentDetails = try await repository.getById(employee.id) }
            catch { errorMessage = "\(error)" }
            print(errorMessage)
        }
    }
}