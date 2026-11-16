//
//  DashboardShiftSummaryView.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/9/26.
//

import SwiftUI
struct DashboardShiftSummaryView: View {
    @State private var viewModel: ViewModel
    
    init(repository: any RepositoryProtocol<DasboardShift>) {
        viewModel = ViewModel(repository: repository)
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.summaryShifts) { employee in
                HStack {
                    Text("\(employee.firstName) \(employee.lastName)")
                    
                    Spacer()
                    
                    Text(employee.shift)
                }
            }
        }
        .task {
            await viewModel.loadShifts()
        }
    }
}
extension DashboardShiftSummaryView {
    @Observable
    class ViewModel: Failable {
        private let repository: any RepositoryProtocol<DasboardShift>
        init(repository: any RepositoryProtocol<DasboardShift>) {
            self.repository = repository
        }
        var errorMessage: String = ""
        var shifts: [DasboardShift] = []
        var summaryShifts: [DasboardShift] {
            Array(shifts.prefix(3))
        }
        func loadShifts() async {
            do {
                shifts = try await repository.getAll()
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}
