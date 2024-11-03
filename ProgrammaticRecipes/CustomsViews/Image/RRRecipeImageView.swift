//
//  RRRecipeImageView.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 03/11/24.
//

import UIKit

class RRRecipeImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func ConfigureImageView(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10.0
        clipsToBounds = true
        backgroundColor = .systemGray
    }

}
