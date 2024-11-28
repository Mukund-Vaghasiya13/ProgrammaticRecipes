//
//  RRBodyLable.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 25/10/24.
//

import UIKit

class RRBodyLable: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text title:String,FG textColor:UIColor,NoOFLine:Int){
        super.init(frame: .zero)
        self.text = title
        self.textColor = textColor
        numberOfLines = NoOFLine
        ConfigureLable()
    }
    
    private func ConfigureLable(){
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 16)
        minimumScaleFactor = 0.8
        lineBreakMode = .byTruncatingTail
    }
}
