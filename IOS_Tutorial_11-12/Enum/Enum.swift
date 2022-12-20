//
//  Enum.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 21/12/2022.
//

import Foundation

enum ConstantsAPI: String {
    case baseURL = "https://api.github.com/"
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
