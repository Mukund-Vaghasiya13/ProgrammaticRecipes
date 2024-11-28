//
//  UserRecipeItem.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/11/24.
//

import UIKit

class UserRecipeItem: UICollectionViewCell {
    static let id = "RRcell"
    var ItemImage = RRDynamicImageView(style: .roundedRect)
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    func SetImage(url:String){
        ItemImage.DownloadImage(url: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        addSubview(ItemImage)
        
        NSLayoutConstraint.activate([
            ItemImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            ItemImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            ItemImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),
            ItemImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -3)
        
        ])
    }
    
}
