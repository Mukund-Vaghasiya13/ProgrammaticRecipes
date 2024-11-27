//
//  RRHeadingLabel.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/10/24.
//

import UIKit

class RRHeadingLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fgColor:UIColor,alignment:NSTextAlignment,font:CGFloat,text:String){
        super.init(frame: .zero)
        self.textColor = fgColor
        self.textAlignment = alignment
        self.font = UIFont.systemFont(ofSize: font,weight: .bold)
        self.text = text
        ConfigureImageView()
    }
    
    private func ConfigureImageView(){
        translatesAutoresizingMaskIntoConstraints = false
        //MARK: IF NEEDED MORE
    }
}
