//
//  File.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 20/12/2022.
//

import Foundation

protocol APIRespository {
    associatedtype T
    associatedtype I
    func getUsersByName(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getFollowers(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getFollowing(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getDataUser(name: String, completion: @escaping (I?, Error?) -> Void)
}
