//
//  Recipe.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 31/10/24.
//

import Foundation

struct Recipe:Codable,Hashable{
    var _id:String?
    var userId:String?
    var title:String?
    var image:String?
    var description:String?
    var ingredients:String?
}

///"http://localhost:3000/api/v1/Recipe/list?page=1"
