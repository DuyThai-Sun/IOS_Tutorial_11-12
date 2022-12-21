//
//  UserRepository.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 20/12/2022.
//

import Foundation
final class UserRepository: APIRespository {
    private let callAPI = APICaller.shared
    
    func getUsersByName(name: String, completion: @escaping ([User]?, Error?) -> Void) {
        callAPI.getJSON(urlApi: "\(ConstantsAPI.baseURL.rawValue)search/users?q=\(name)") { (data: Users?, error) in
            if let data = data {
                completion(data.items, nil)
            }
        }
    }
    
    func getUserDetail(urlApi: String, completion: @escaping (User?, Error?) -> Void) {
        callAPI.getJSON(urlApi: urlApi) { (data: User?, error) in
            if let data = data {
                completion(data, nil)
            }
        }
    }
    
}
