//
//  LoginViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 24/10/24.
//

import UIKit

class LoginViewController: UIViewController {

    var username = RRTextField(with: "Enter Username or Email", is: false)
    var password = RRTextField(with: "Enter Password", is: true)
    var Errorlable = RRErrorLabel(text: "")
    var LoginButton = RRButton(with: "Login", BG: .systemGreen, FG: .white)
    var signUpButton = RRTextButton(with: "Create user!", also: .systemBlue, and: .systemGreen)
    var orLabel = RRBodyLable(text: "Or", FG: .label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let token = try TokenManager.shared.GetToken()
            if let token = token{
                navigationController?.pushViewController(HomeViewController(), animated: true)
            }
        }catch(_){
            print("Errror💩")
            //MARK: handle Error
        }
        
        ConfigureNavBar()
        ConfigureView()
        username.delegate = self
        password.delegate = self
    }
    
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        username.becomeFirstResponder()
    }
    
    private func ConfigureView(){
        DismissKeyBord()
        ViewHandler()
        
        view.addSubview(orLabel)
        signUpButton.addTarget(self, action: #selector(SignUpClickAction), for: .touchUpInside)
        LoginButton.addTarget(self, action: #selector(LoginClickAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            username.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            username.heightAnchor.constraint(equalToConstant: 55),
            
            password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10),
            password.heightAnchor.constraint(equalToConstant: 55),
            
            Errorlable.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10),
            Errorlable.heightAnchor.constraint(equalToConstant: 18),
            
            LoginButton.topAnchor.constraint(equalTo: Errorlable.bottomAnchor, constant: 10),
            LoginButton.heightAnchor.constraint(equalToConstant: 55),
            
            orLabel.topAnchor.constraint(equalTo: LoginButton.bottomAnchor, constant: 10),
            orLabel.heightAnchor.constraint(equalToConstant: 23),
            orLabel.centerXAnchor.constraint(equalTo: LoginButton.centerXAnchor),
            orLabel.widthAnchor.constraint(equalToConstant: 23),
            
            signUpButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 10),
            signUpButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func ViewHandler(){
        let viewArray = [username,password,Errorlable,LoginButton,signUpButton]
        for i in viewArray{
            view.addSubview(i)
            NSLayoutConstraint.activate([
                i.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                i.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            ])
        }
    }
    
    @objc func SignUpClickAction(){
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    @objc func LoginClickAction(){
        if Validation(){
            NetworkCall()
        }
    }
    
    
    private func  Validation()->Bool{
        if let usenametext = username.text, usenametext.isEmpty{
            Errorlable.text = "Enter username"
            username.becomeFirstResponder()
            return false
        } else if let passwordtext = password.text,passwordtext.isEmpty{
            Errorlable.text = "Enter Password"
            password.becomeFirstResponder()
            return false
        }else{
            Errorlable.text = ""
            return true
        }
    }
    
    func NetworkCall(){
        let url = "http://localhost:3000/api/v1/User/login"
        let body = [
            "usernameOrEmail":username.text ?? "",
            "password":password.text ?? ""
        ]
        
        do{
            let data =  try JSONEncoder().encode(body)
            NetworkHandler.shared.PostRequest(for: LoginModle.self, endpoint: url, Body: data, header: nil) { result in
                switch result{
                case .success(let data):
                    print(data)
                    do{
                       try TokenManager.shared.SetTokenDataLocally(loginData: data)
                        DispatchQueue.main.async{
                            self.navigationController?.pushViewController(HomeViewController(), animated: true)
                        }
                    }catch(let e){
                        print(e)
                    }
                        break
                case .failure(let err):
                    print(err.technicalDetails ?? "FAIL🤧")
                      break
                }
            }
        }catch{
            print("Encode Fail")
        }
    }
    
}



extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Validation(){
            NetworkCall()
        }
        return true
    }
}
