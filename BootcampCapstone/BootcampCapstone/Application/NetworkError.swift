//
//  NetworkError.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

enum NetworkError: Error {
    case invalidURL
    case noConnection
    case badResponse(statusCode: Int)
    case encodingFailed(underlying: Error)
    case decodingFailed(underlying: Error)
    case unauthorized
    case missingAuthToken
}
