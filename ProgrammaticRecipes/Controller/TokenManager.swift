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
    
    private var key = "Token"
    
    func SetTokenDataLocally(loginData:LoginModle){
        let encript = try? JSONEncoder().encode(loginData)
        UserDefaults.standard.setValue(encript, forKey: key)
    }

    func GetTokenDataLocally() -> LoginModle? {
        let data = UserDefaults.standard.object(forKey: key) as? Data
        
        guard let data = data else{ return nil }
        
        let loginData = try? JSONDecoder().decode(LoginModle.self, from: data )
        return loginData
    }
    
    func GetToken() ->String? {
        let loginData = GetTokenDataLocally()
        return loginData?.Logintoken ?? nil
    }
    
    func LogoutDeleteToken(){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
