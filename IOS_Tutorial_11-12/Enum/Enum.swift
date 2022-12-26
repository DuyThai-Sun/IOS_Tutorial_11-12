//
//  Enum.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 21/12/2022.
//

import Foundation

enum ConstantsAPI: String {
    case baseURL = "https://api.github.com/"
    case informUser = "https://api.github.com/users/"
}

enum NetworkError: Error {
    case badResponse
    case badStatusCode(Int)
    case badData
}

enum MethodRequest: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
