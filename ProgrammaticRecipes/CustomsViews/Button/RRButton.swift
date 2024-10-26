//
//  RRButton.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 24/10/24.
//

import UIKit

class RRButton: UIButton {
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigButton()
    }
    
    override var isHighlighted: Bool{
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with title:String,BG bgColor:UIColor,FG forColor:UIColor){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.setTitleColor(forColor, for: .normal)
        ConfigButton()
    }
    
    private func ConfigButton(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        titleLabel?.font = UIFont.systemFont(ofSize: 20,weight: .semibold)
    }
    
}
