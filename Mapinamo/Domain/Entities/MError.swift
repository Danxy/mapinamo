//
//  MError.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

public let ERROR_GENERAL_ERROR = -1

enum MError: Error {
    case networkError
    case unknownError
    case mError(httpCode: Int, code: Int, message: String)
}

struct ErrorResponse: Codable {
    let code: Int
    let message: String
}
