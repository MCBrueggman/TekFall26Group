//
//  TieredCasheRepoBase.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/21/26.
//

enum CachingConfigurationError: Error {
    case missingManagedObjectConext
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectCointext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
