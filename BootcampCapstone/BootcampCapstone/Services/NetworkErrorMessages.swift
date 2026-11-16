//
//  NetworkErrorMessages.swift
//  BootcampCapstone
//
//  Created by Shawn Defibaugh on 10/18/26.
//

import Foundation


extension NetworkError: LocalizedError {
    var errorDescription: String? {

        switch self {
        case .missingAuthToken, .unauthorized:
            return "Session expired. Log in again"
        case .badResponse(let statusCode):
            return "Bad response from server: \(statusCode)"
        case .decodingFailed:
            return "Data could not be decoded"
        case .invalidURL:
            return "Invalid URL"
        case .noConnection:
            return "No internet connection"
        case .encodingFailed:
            return "Data could not be encoded"
        }
    }
}
