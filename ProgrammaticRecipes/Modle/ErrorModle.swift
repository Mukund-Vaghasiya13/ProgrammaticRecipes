//
//  ErrorModle.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation

struct ErrorModle:Codable,Error{
    let message:String?
    let technicalDetails:String?
    let statusCode:Int?
}
