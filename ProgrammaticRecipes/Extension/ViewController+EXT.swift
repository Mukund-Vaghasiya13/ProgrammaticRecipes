//
//  ViewController+EXT.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import UIKit


extension UIViewController{
    func DismissKeyBord(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:))))
    }
    
    func ShowAlert(message:String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        navigationController?.present(alert, animated: true)
    }
}
