//
//  InventoryRepo.swift
//  BootcampCapstone
//  Created by user301537 on 10/23/26.
//

import Foundation

class RemoteInventoryRepo {
    private let urlBase: String
    private let authStatus: AuthStatus
    
    init(urlBase: String, authStatus: AuthStatus) {
        self.urlBase = urlBase
        self.authStatus = authStatus
    }
    
    func getAll() async throws -> [InventoryItem] {
        let urlString = "\(urlBase)/Inventory"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authStatus.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(statusCode: -1)
        }
        
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 { throw NetworkError.unauthorized }
            throw NetworkError.badResponse(statusCode: http.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([InventoryItem].self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
    
    func getById(_ id: Int) async throws -> InventoryItem? {
        let items = try await getAll()
        return items.first { $0.id == id }
    }
}	
