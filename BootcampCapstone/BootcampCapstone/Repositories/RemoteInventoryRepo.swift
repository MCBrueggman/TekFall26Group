//
//  RemoteInventoryRepo.swift
//  BootcampCapstone
//

import Foundation

class RemoteInventoryRepo: RepositoryProtocol<InventoryItem> {
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
        if let token = authStatus.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([InventoryItem].self, from: data)
    }
    
    func getById(_ id: Int) async throws -> InventoryItem? {
        let items = try await getAll()
        return items.first { $0.id == id }
    }
}