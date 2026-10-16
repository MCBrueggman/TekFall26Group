//
//  DashboardShiftDetailsView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//  Modified by Shawn Defibaugh
//

import SwiftUI

enum SortingShifts: String, CaseIterable, Identifiable {
    case all = "All"
    case day = "Day"
    case evening = "Evening"
    case night = "Night"
    
    var id: Self { self }
}

struct DashboardShiftDetailsView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<DasboardShift>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack {
            Text("Employee Shifts")
                .font(.largeTitle)
                .bold()
            
            Picker("Shift", selection: $viewModel.shiftFilter) {
                ForEach(SortingShifts.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List(viewModel.filteredShifts) { employee in
                VStack(alignment: .leading) {
                    Text("\(employee.firstName) \(employee.lastName)")
                        .font(.headline)
                    
                    Text("Shift: \(employee.shift)")
                }
            }
            .animation(.default, value: viewModel.shiftFilter)
        }
        .task {
            print("TaskStarted")
            await viewModel.loadShifts()
        }
    }
}

extension DashboardShiftDetailsView {
    @Observable
    class ViewModel: Failable {
        private let repository: any RepositoryProtocol<DasboardShift>
        init(repository: any RepositoryProtocol<DasboardShift>) {
            self.repository = repository
        }
        
        var errorMessage: String = ""
        var shifts: [DasboardShift] = []
        var shiftFilter: SortingShifts = .all
        
        var filteredShifts: [DasboardShift] {
            guard shiftFilter != .all else { return shifts }
            return shifts.filter {
                $0.shift.localizedCaseInsensitiveCompare(shiftFilter.rawValue) == .orderedSame
            }
        }
        
        func loadShifts() async {
            do {
                shifts = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
                print("shift error: \(error)")
            }
        }
    }
}
