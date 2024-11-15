//
//  RecipeListCellTableViewCell.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 01/11/24.
//

import UIKit

class RecipeListCellTableViewCell: UITableViewCell {
    
    var placeHolder = UIImage(named: "Unknown")
    var RecipeListImage = UIImageView(frame: .zero)
    var BodyLable = RRBodyLable(text: "", FG: .black,NoOFLine: 3)
    static var reUseId = "cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ConfigureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func Set(ImageUrl:String?,des:String?){
        self.DownloadImage(url: ImageUrl ?? "")
        BodyLable.text = des
    }
    
    private func DownloadImage(url:String){
        let nssURL = NSString(string: url)
        if let image = NetworkHandler.shared.chache.object(forKey: nssURL){
            self.RecipeListImage.image = image
        }else{
            guard let url = URL(string: url) else{ return }
            URLSession.shared.dataTask(with:url) { data, res, err in
                if err != nil { return }
                guard let _ = res else { return }
                guard let data = data else { return }
                
                if let img = UIImage(data: data) {
                    NetworkHandler.shared.chache.setObject(img, forKey: nssURL)
                    DispatchQueue.main.async {
                        self.RecipeListImage.image = img
                    }
                }
            }.resume()
        }
    }
    
    
    private func ConfigureView(){
        RecipeListImage.translatesAutoresizingMaskIntoConstraints = false
        RecipeListImage.image = placeHolder
        RecipeListImage.layer.cornerRadius = 10
        RecipeListImage.clipsToBounds = true
        addSubview(RecipeListImage)
        addSubview(BodyLable)
        
        NSLayoutConstraint.activate([
        
            RecipeListImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            RecipeListImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            RecipeListImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            RecipeListImage.heightAnchor.constraint(equalToConstant: 160),
            
            BodyLable.topAnchor.constraint(equalTo: RecipeListImage.bottomAnchor, constant: 10),
            BodyLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            BodyLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            BodyLable.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
