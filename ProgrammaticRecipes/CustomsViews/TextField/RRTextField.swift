//
//  RRTextField.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 24/10/24.
//

import UIKit

class RRTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(with PlaceHolder:String,is secure:Bool){
        super.init(frame: .zero)
        self.placeholder = PlaceHolder
        self.isSecureTextEntry = secure
        ConfigureTextField()
    }
    
    private func ConfigureTextField(){
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = .no
        font = UIFont.systemFont(ofSize: 20)
        borderStyle = .roundedRect
    }

}
