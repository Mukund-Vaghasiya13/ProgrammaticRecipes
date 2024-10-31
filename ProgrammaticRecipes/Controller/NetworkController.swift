//
//  NetworkController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation

class NetworkHandler{
    
    static var shared = NetworkHandler()
    
    private init(){}
    
    func PostRequest<T:Codable>(for:T.Type,endpoint:String,Body:Data,header:[String:String]?,complition:@escaping (Result<T,ErrorModle>)->Void){
        
        guard let url = URL(string: endpoint) else{
            let error = ErrorModle(message: "Network Issue", technicalDetails: "Url inValid", statusCode: nil)
            complition(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = Body
        
        if let header = header{
            for i in header.keys{
                request.setValue(header[i], forHTTPHeaderField: i)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            if let err = err {
                let error =  ErrorModle(message: "Network Call Fail", technicalDetails: err.localizedDescription, statusCode: nil)
                complition(.failure(error))
                return
            }
            
            guard let data = data else{
                let error =  ErrorModle(message: "Network Call Fail", technicalDetails: "Data Empety", statusCode: nil)
                complition(.failure(error))
                return
            }
            
            if let res = res as? HTTPURLResponse {
                 
                //TODO: Refactoring....!
                if res.statusCode == 201{
                    do{
                        let data = try JSONDecoder().decode(T.self, from: data)
                        complition(.success(data))
                    }catch{
                        print("Decoding Fail")
                    }
                }else{
                    do{
                        let data = try JSONDecoder().decode(ErrorModle.self, from: data)
                        complition(.failure(data))
                    }catch{
                        print("Decoding Fail")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    func GetRequest<T:Codable>(for:T.Type,endpoint:String,headers:[String:String]?,complition : @escaping (Result<T,ErrorModle>)-> Void){
        guard let url = URL(string: endpoint) else{
            let error = ErrorModle(message: "Network Issue", technicalDetails: "Url inValid", statusCode: nil)
            complition(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let headers {
            for i in headers.keys{
                request.setValue(headers[i], forHTTPHeaderField: i)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            if let err = err {
                let error =  ErrorModle(message: "Network Call Fail", technicalDetails: err.localizedDescription, statusCode: nil)
                complition(.failure(error))
                return
            }
            
            guard let data = data else{
                let error =  ErrorModle(message: "Network Call Fail", technicalDetails: "Data Empety", statusCode: nil)
                complition(.failure(error))
                return
            }
            
            if let res = res as? HTTPURLResponse {
                 
                //TODO: Refactoring....!
                if res.statusCode == 200{
                    do{
                        let data = try JSONDecoder().decode(T.self, from: data)
                        complition(.success(data))
                    }catch{
                        print("Decoding Fail")
                    }
                }else{
                    do{
                        let data = try JSONDecoder().decode(ErrorModle.self, from: data)
                        complition(.failure(data))
                    }catch{
                        print("Decoding Fail")
                    }
                }
            }
        }
        
        task.resume()
    }
    
//    private func DecodingData<T:Codable>(for:T.Type,Case:Bool,data:Data,complition: @escaping (Result<T,ErrorModle>)->Void){
//        do{
//            let data = try JSONDecoder().decode(T.self, from: data)
//            if Case{
//                complition(.success(data))
//            }else{
//                complition(.failure(data as! ErrorModle))
//            }
//        }catch{
//            let error = ErrorModle(message: "Network Issue", technicalDetails: "Decoding Fail", statusCode: nil)
//            complition(.failure(error))
//        }
//    }
    
}

