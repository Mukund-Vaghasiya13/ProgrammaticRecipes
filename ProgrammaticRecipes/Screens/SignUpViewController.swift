//
//  SignUpViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 25/10/24.
//

import UIKit

class SignUpViewController: UIViewController {

    var username = RRTextField(with: "Enter Username or Email", is: false)
    var password = RRTextField(with: "Enter Password", is: true)
    var Errorlable = RRErrorLabel(text: "")
    var email = RRTextField(with: "Enter Email", is: false)
    //MARK: because we will do signp with login
    var LoginButton = RRButton(with: "Signup", BG: .systemGreen, FG: .white)
    var orLabel = RRBodyLable(text: "Or", FG: .label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        ConfigureView()
    }
    
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Signup"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func ConfigureView(){
        DismissKeyBord()
        
        email.becomeFirstResponder()
        
        //MARK: Google Button if i will do google login then
        ViewHandler()
        view.addSubview(orLabel)
        
        
        username.delegate = self
        password.delegate = self
        email.delegate = self
        
        NSLayoutConstraint.activate([
         
            email.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            email.heightAnchor.constraint(equalToConstant: 55),
            
            username.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
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
        
        ])
        
        LoginButton.addTarget(self, action: #selector(SingUpAction), for: .touchUpInside)
    }
    
    @objc func SingUpAction(){
        if Validation(){
            NetworkCall()
        }
    }
    
    func NetworkCall(){
        let url = "http://localhost:3000/api/v1/User/register"
        let body = [
            "email":email.text!,
            "username":username.text!,//MARK: Validating Before Call
            "password":password.text!
        ]
        
        do{
            let data =  try JSONEncoder().encode(body)
            NetworkHandler.shared.PostRequest(for: LoginModle.self, endpoint: url, Body: data, header: nil) { result in
                switch result{
                case .success(let data):
                    print(data)
                    TokenManager.shared.SetTokenDataLocally(loginData: data)
                    DispatchQueue.main.async{
                        self.navigationController?.pushViewController(HomeViewController(), animated: true)
                    }
                        break
                case .failure(let err):
                    print(err.technicalDetails ?? "FAIL🤧")
                    if err.statusCode == nil{
                        DispatchQueue.main.async {
                            self.ShowAlert(message: err.technicalDetails ?? "nil", title: err.message ?? "nil")
                        }
                    }else{
                        DispatchQueue.main.async {self.Errorlable.text = err.message}
                    }
                      break
                }
            }
        }catch{
            print("Encode Fail")
        }
    }
    
    private func ViewHandler(){
        let viewArray = [email,username,password,Errorlable,LoginButton]
        for i in viewArray{
            view.addSubview(i)
            NSLayoutConstraint.activate([
                i.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                i.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            ])
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
        }else if let emailtext = email.text,emailtext.isEmpty{
            Errorlable.text = "Enter Email"
            password.becomeFirstResponder()
            return false
        }
        else{
            Errorlable.text = ""
            return true
        }
    }
    
}


extension SignUpViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Validation(){
            NetworkCall()
        }
        return true
    }
}
