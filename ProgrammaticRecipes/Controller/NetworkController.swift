//
//  NetworkController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import Foundation


struct ImageRequest {
    var attachment : Data
    var fileName : String
}

struct Payload{
    var imageData:ImageRequest
    var fields:[String:String]
}

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
    
    
    
    func MultiparFormRequest<T:Codable>(for:T.Type,endpoint:String,headers:[String:String]?,payload:Payload,complition:@escaping (Result<T,ErrorModle>)->Void){
        
        let lineBreak = "\r\n"
        
        guard let url = URL(string: endpoint) else{
            let error = ErrorModle(message: "Network Issue", technicalDetails: "Url inValid", statusCode: nil)
            complition(.failure(error))
            return
        }
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = "POST"
        if let headers = headers{
            for headervalue in headers.keys{
                urlRequest.setValue(headers[headervalue]!, forHTTPHeaderField: headervalue)
            }
        }
        //Main Boundary start
        let boundary = "---------------------------------\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        var requestData = Data()
        
        for (key,value) in payload.fields{
            //Countent-Boundary
            requestData.append("--\(boundary)\r\n" .data(using: .utf8)!)
            
            //Key Of Content-Boundary
            requestData.append("content-disposition: form-data; name=\"\(key)\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
            
            //Value Of Content-Boundary
            requestData.append("\(value)\(lineBreak)".data(using: .utf8)!)
        }
        
        //MARK: Add image file data
        //Content start
        requestData.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        
        //Key
        requestData.append("Content-Disposition: form-data; name=\"\(payload.imageData.fileName)\"; filename=\"image.jpg\"\(lineBreak)".data(using: .utf8)!)
        requestData.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        
        //Value
        requestData.append(payload.imageData.attachment)
        requestData.append("\(lineBreak)".data(using: .utf8)!)
        
        
        //End Main 🫡
        requestData.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        //MARK: DEBUG BreakPoint
        let str = String(decoding: requestData, as: UTF8.self)
        print(str)
        
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, res, error in
            if let err = error {
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
                        let resultdata = try JSONDecoder().decode(T.self, from: data)
                        complition(.success(resultdata))
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
}

//TODO: Refactoring

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
