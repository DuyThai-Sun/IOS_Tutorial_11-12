//
//  UserModel.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 20/12/2022.
//

import Foundation

struct UserModel: Codable {
    let isFavorited = false
    let login: String
    let id: Int
    let avatarUrl: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case reposUrl = "repos_url"
    }
}

struct Users: Codable {
    let totalCount: Int
    let items: [UserModel]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }
}

