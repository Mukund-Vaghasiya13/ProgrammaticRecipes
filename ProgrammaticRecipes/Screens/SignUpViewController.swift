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
    var orLabel = RRBodyLable(text: "Or", FG: .label,NoOFLine: 1)
    
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
    
    private func  Validation(){
        if let usenametext = username.text, usenametext.isEmpty{
            Errorlable.text = "Enter username"
            username.becomeFirstResponder()
        } else if let passwordtext = password.text,passwordtext.isEmpty{
            Errorlable.text = "Enter Password"
            password.becomeFirstResponder()
        }else if let emailtext = email.text,emailtext.isEmpty{
            Errorlable.text = "Enter Email"
            password.becomeFirstResponder()
        }
        else{
            Errorlable.text = ""
        }
    }
    
}


extension SignUpViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Validation()
        return true
    }
}
