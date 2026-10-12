//
//  DashboardShiftDetailsView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//

import SwiftUI
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
            
            List(viewModel.shifts) { employee in
                        VStack(alignment: .leading) {
                            Text("\(employee.firstName) \(employee.lastName)")
                                .font(.headline)
                            
                            Text("Shift: \(employee.shift)")
                        }
                    }
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
