//
//  TokenManager.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation

class TokenManager{
    
    private init(){}
    
    static var shared = TokenManager()
    
    func SetTokenDataLocally(loginData:LoginModle) throws {
        do{
           let data =  try EncriptData(data: loginData)
            UserDefaults.standard.setValue(data, forKey: "Token")
        }catch(let e){
            throw e
        }
    }
    
    func GetTokenDataLocally() throws ->LoginModle {
        let data = UserDefaults.standard.object(forKey: "Token")  as? Data
        guard let data = data else {
            throw ErrorModle(message: "OOPS! something Went Wrong", technicalDetails: "Data nil in Token Manager", statusCode: nil)
        }
        do{
            return try DecodingData(data: data)
        }catch(let e){
            throw e
        }
    }
    
    
    
    func GetToken() throws ->String? {
        let data = UserDefaults.standard.object(forKey: "Token")  as? Data
        guard let data = data else {
            throw ErrorModle(message: "OOPS! something Went Wrong", technicalDetails: "Data nil in Token Manager", statusCode: nil)
        }
        do{
            let data =  try DecodingData(data: data)
            return data.Logintoken
        }catch(let e){
            throw e
        }
    }
    
    private func DecodingData(data:Data) throws -> LoginModle{
        do{
            let data = try JSONDecoder().decode(LoginModle.self, from: data)
            return data
        }catch{
            throw ErrorModle(message: "OOPS! something Went Wrong", technicalDetails:"Decoding Fail in TokenManager", statusCode: nil)
        }
    }
    
    private func EncriptData(data:LoginModle) throws -> Data{
        do{
            let encript = try JSONEncoder().encode(data)
            return encript
        }catch{
            throw ErrorModle(message: "OOPS! something Went Wrong", technicalDetails:"Encoding Fail in TokenManager", statusCode: nil)
        }
    }
}
