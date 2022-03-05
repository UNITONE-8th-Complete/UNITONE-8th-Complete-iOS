//
//  APIError.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import Foundation

enum APIError: Error {
    case decode
    case http(status: Int)
    case unknown
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .decode:
            return "Decode Error"
        case let .http(status):
            return "HTTP Error: \(status)"
        case .unknown:
            return "Unknown Error"
        }
    }
}