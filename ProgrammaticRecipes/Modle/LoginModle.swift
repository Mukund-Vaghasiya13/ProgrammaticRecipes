//
//  LoginModle.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation

struct LoginModle:Codable{
    let message:String?
    let Logintoken:String?
    let statusCode:Int?
    let user:User
}

struct User:Codable{
    let _id:String?
    let username:String?
    let email:String?
    let profilePicture:String?
}
