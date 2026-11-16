//
//  RemoteEmployeeRepo.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

import Foundation

class RemoteEmployeeRepo: RemoteRepositoryBase<Employee>, RepositoryProtocol<Employee> {
    
    private let urlBase: String
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        super.init(authStatus: authStatus)
    }
   
    func getAll() async throws -> [Employee] {
        let urlString = "\(urlBase)/Employee"
        return try await fetchAll(urlString)
    }
    
    func getById(_ id: Int) async throws -> Employee? {
        let urlString = "\(urlBase)/Employee/\(id)"
        return try await fetchOne(urlString)
    }
    
    func insert(_ item: Employee) async throws -> Employee {
        let urlString = "\(urlBase)/Employee/"
        return try await post(urlString, send: item)
        
    }
    
    func update(_ item: Employee) async throws {
        let urlString = "\(urlBase)/Employee"
        try await put("\(urlString)/personal/\(item.id)",
                      send: PersonalUpdate(firstName: item.firstName,
                                           middleName: item.middleName,
                                           lastName: item.lastName,
                                           suffix: item.suffix))
    }
    
    func delete(_ item: Employee) async throws {
        let urlString = "\(urlBase)/Employee/\(item.id)"
        try await del(urlString)
    }
    
}
