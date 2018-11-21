//
//  UserModel.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/20/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import Foundation
class User{
    var id: String
    var displayName: String
    var email: String
    var name: String
    var phoneNum: String
    var language: String
    var birthdate: String
    var address: String
    var city: String
    var state: String
    var country: String
    var zipcode: String
    
    init(id: String, displayName: String, email:String, name:String, phoneNum:String, language:String, birthdate: String, address: String, city:String, state:String, country:String, zipcode: String) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.name = name
        self.phoneNum = phoneNum
        self.language = language
        self.birthdate = birthdate
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.zipcode = zipcode
    }
}
