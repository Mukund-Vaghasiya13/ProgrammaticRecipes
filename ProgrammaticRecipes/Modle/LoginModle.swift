//
//  LoginModle.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation

struct LoginModle:Codable{
    var message:String?
    var Logintoken:String?
    var statusCode:Int?
    var user:User
}

struct User:Codable{
    let _id:String?
    let username:String?
    let email:String?
    let profilePicture:String?
}
