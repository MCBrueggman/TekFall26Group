//
//  RemoteDashboardShiftRepo.swift
//  BootcampCapstone
//
//  Created by user301407 on 10/1/26.
//

import Foundation

class RemoteDashboardShiftRepo: RemoteRepositoryBase<DasboardShift>, RepositoryProtocol<DasboardShift> {

    private let urlBase: String

    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }

    func getAll() async throws -> [DasboardShift] {
        let urlString = "\(urlBase)/Dashboard/shifts"

            print("Fetching employee shifts from: \(urlString)")

            let shifts = try await fetchAll(urlString)

            print("Employee shifts received: \(shifts.count)")
            print(shifts)

            return shifts
    }

    func getById(_ id: Int) async throws -> DasboardShift? {
        return nil
    }

    func insert(_ item: DasboardShift) async throws -> DasboardShift {
        throw URLError(.unsupportedURL)
    }

    func update(_ item: DasboardShift) async throws {
        throw URLError(.unsupportedURL)
    }

    func delete(_ item: DasboardShift) async throws {
        throw URLError(.unsupportedURL)
    }

}
