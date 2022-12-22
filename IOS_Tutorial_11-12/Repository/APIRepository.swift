//
//  File.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 20/12/2022.
//

import Foundation

protocol APIRespository {
    associatedtype T
    associatedtype I
    func getUsersByName(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getFollowersUsers(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getFollowingUsers(name: String, completion: @escaping ([T]?, Error?) -> Void)
    func getInformUser(name: String, completion: @escaping (I?, Error?) -> Void)
}
