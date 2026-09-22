//
//  MockEmployeeRepo.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

class MockEmployeeRepo: RepositoryProtocol<Employee> {
    
    private var employees = [
        Employee(id: 001, firstName: "", middleName: "", lastName: "", suffix: "", title: "", jobTitle: "",  department: "")
    ]
    
    func getAll() async throws -> [Employee] {
        employees
    }
    
    func getById(_ id: Int) async throws -> Employee? {
        employees.first(where: { $0.id == id })
    }
    
    func insert(_ item: Employee) async throws -> Employee {
        throw FeatureError.notImplemented
    }
    
    func update(_ item: Employee) async throws {
        throw FeatureError.notImplemented
    }
    
    func delete(_ item: Employee) async throws {
        throw FeatureError.notImplemented
    }
   
    
}
