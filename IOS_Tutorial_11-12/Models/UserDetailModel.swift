//
//  UserDetailModel.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 22/12/2022.
//

import Foundation

struct UserDetail: Codable {
    let name: String?
    let company: String?
    let bio: String?
    let publicRepos: Int?
    let location: String?
    let followers: Int?
    let following: Int?
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case company = "company"
        case bio = "bio"
        case publicRepos = "public_repos"
        case location = "location"
        case followers = "followers"
        case following = "following"
        case reposUrl = "repos_url"
    }
}
