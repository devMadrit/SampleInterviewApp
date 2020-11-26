//
//  UserModel.swift
//  SampleInterviewApp
//
//  Created by Kacabumi Madrit on 25.11.20.
//

import Foundation

internal struct UserModel: Codable, Resource {
    
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case username = "username"
        case email = "email"
    }
}
