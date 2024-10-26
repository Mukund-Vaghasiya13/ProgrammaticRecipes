//
//  RRTextButton.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 25/10/24.
//

import UIKit

class RRTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with title:String,also color:UIColor,and activeColor:UIColor){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(activeColor, for: .highlighted)
        ConfigureButton()
    }
    
    private func ConfigureButton(){
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
    }
}
