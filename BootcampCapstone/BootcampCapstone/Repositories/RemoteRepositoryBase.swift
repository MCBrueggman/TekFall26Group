//
//  RemoteRepositoryBase.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//


import Foundation
internal import CoreData

class RemoteRepositoryBase<Item: Codable> {
    
    private var authStatus: AuthStatus
    var implicitContext: NSManagedObjectContext? = nil
    
    init(authStatus: AuthStatus) { self.authStatus = authStatus }
    
    // MARK: fetchALL Function
    func fetchAll(_ urlString: String) async throws -> [Item] {
        let request = try createRequest(urlString)
        let data = try await executeRequest(request)
        
        do {
            let decoder = makeDecoder()
            return try decoder.decode([Item].self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
    
    // MARK: fetchOne Function
    func fetchOne(_ urlString: String) async throws -> Item {
        let request = try createRequest(urlString)
        let data = try await executeRequest(request)
        
        do {
            let decoder = makeDecoder()
            return try decoder.decode(Item.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
    
    // MARK: Post Function
    func post(_ urlString: String, send item: Item) async throws -> Item {
        
        var request = try createRequest(urlString)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do    { request.httpBody = try JSONEncoder().encode(item) }
        catch { throw NetworkError.encodingFailed(underlying: error) }
        
        let data = try await executeRequest(request)
        
        do {
            let decoder = makeDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Item.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
    
    // MARK: Put function
    func put(_ urlString: String, send item: Item) async throws {
        
        var request = try createRequest(urlString)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do    { request.httpBody = try JSONEncoder().encode(item) }
        catch { throw NetworkError.encodingFailed(underlying: error) }
        
        let _ = try await executeRequest(request)
        
    }
    
    // MARK: Delete Function
    func del(_ urlString: String) async throws {
        var request = try createRequest(urlString)
        request.httpMethod = "Delete"
        let _ = try await executeRequest(request)
        
    }
    
    // MARK: - Private ulility methods
    private func createRequest(_ urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        guard let auth = authStatus.authToken, !auth.isEmpty else  { throw NetworkError.missingAuthToken }
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func executeRequest(_ request: URLRequest, isRetry: Bool = false) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.badResponse(statusCode: -1)
        }
        guard (200...299).contains(http.statusCode) else {
            if http.statusCode == 401 {
                guard !isRetry,
                      let refresh = authStatus.refreshToken,
                        !refresh.isEmpty,
                      let auth = authStatus.authToken,
                        !auth.isEmpty else  {
                    throw NetworkError.unauthorized
                }
                
                let refreshResult = try await AuthService.shared.refreshToken(authToken: auth, refreshToken: refresh)
                guard refreshResult.success else { throw NetworkError.unauthorized }
                
                authStatus.updateLoginStatus(success: refreshResult.success, authToken: refreshResult.accessToken, refreshToken: refreshResult.refreshToken)
                
                var newRequest = request
                newRequest.setValue("Bearer \(authStatus.authToken!)", forHTTPHeaderField: "Authorization")
                
                return try await executeRequest(newRequest, isRetry: true)
            }
            throw NetworkError.badResponse(statusCode: http.statusCode)
        }
        
        return data
    }
    
    private func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if let context = implicitContext {
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let withoutFractional = ISO8601DateFormatter()
        withoutFractional.formatOptions = [.withInternetDateTime]
        
        let plainFormatter = DateFormatter()
        plainFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        plainFormatter.timeZone = TimeZone(identifier: "UTC")
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = withFractional.date(from: dateString)     { return date }
            if let date = withoutFractional.date(from: dateString)  { return date }
            if let date = plainFormatter.date(from: dateString)     { return date }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
        }
        return decoder
    }
        
}
