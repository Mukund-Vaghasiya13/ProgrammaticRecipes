//
//  RRLabel.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 24/10/24.
//

import UIKit

class RRErrorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text:String){
        super.init(frame: .zero)
        self.text = text
        
        ConfigureLabel()
    }
    
    private func ConfigureLabel(){
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .systemRed
        font = UIFont.systemFont(ofSize: 16)
    }

}
