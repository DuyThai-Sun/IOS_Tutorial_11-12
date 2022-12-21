//
//  File.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 20/12/2022.
//

import Foundation

protocol APIRespository {
    associatedtype T
    func getUsersByName(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getUserDetail(urlApi: String, completion: @escaping (T?, Error?) -> Void)
}
