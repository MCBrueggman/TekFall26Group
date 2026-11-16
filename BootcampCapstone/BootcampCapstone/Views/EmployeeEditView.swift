//
//  EmployeeEditView.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 10/15/26.
//

import SwiftUI

struct EmployeeEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var employee: Employee
    let onSave: (Employee) -> Void
    private var canSave: Bool {
        let first = employee.firstName.trimmingCharacters(in: .whitespaces)
        let last = employee.lastName.trimmingCharacters(in: .whitespaces)
        return first.contains(where: \.isLetter) && last.contains(where: \.isLetter)
    }
    
    init(employee: Employee, onSave: @escaping (Employee) -> Void) {
        _employee = State(initialValue: employee)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("First Name", text: Binding(
                    get: { employee.firstName },
                    set: { employee.firstName = sanitized($0) }
                )).textInputAutocapitalization(.words)
                TextField("Middle Name", text: Binding(
                    get: { employee.middleName ?? "" },
                    set: { let clean = sanitized($0); employee.middleName = clean.isEmpty ? nil : clean }
                )).textInputAutocapitalization(.words)
                TextField("Last Name", text: Binding(
                    get: { employee.lastName },
                    set: { employee.lastName = sanitized($0) }
                )).textInputAutocapitalization(.words)
                TextField("Suffix", text: Binding(
                    get: { employee.suffix ?? "" },
                    set: { let clean = sanitizedSuffix($0); employee.suffix = clean.isEmpty ? nil : clean }
                )).textInputAutocapitalization(.words)
            }
            .navigationTitle("Edit Employee")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let adjusted = employee
                        adjusted.firstName = nameAdjustment(employee.firstName)
                        adjusted.lastName = nameAdjustment(employee.lastName)
                        onSave(adjusted)
                        dismiss()
                    }
                    .disabled(!canSave) // Will not allow a blank submission for first and last name
                }
            }
        }
    }
    // Function that will clean up all whitespaced entered in the text field and then autocapatilize them as well
    private func nameAdjustment(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard let first = trimmed.first else { return trimmed }
        return first.uppercased() + trimmed.dropFirst()
    }
    // Makes it so only these characters can be used in the field and will remove anything that isnt
    private func sanitized(_ text: String) -> String {
        text.filter { $0.isLetter || $0 == " " || $0 == "-" || $0 == "'" || $0 == "’"}
    }
    private func sanitizedSuffix(_ text: String) -> String {
        text.filter { $0.isLetter || $0 == " " || $0 == "-" || $0 == "'" || $0 == "’" || $0 == "." }
    }
}
