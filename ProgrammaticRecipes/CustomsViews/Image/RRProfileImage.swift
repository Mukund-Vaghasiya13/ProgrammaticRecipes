//
//  RRImage.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/10/24.
//

import UIKit

#error("Cache Image")
class RRUserAvtarImage: UIImageView {
    
    private var placeHolder = UIImage(systemName: "person.fill")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DownloadImage(url:String){
        guard let url = URL(string: url) else{ return }
        
        URLSession.shared.dataTask(with:url) { data, res, err in
            if err != nil { return }
            guard let _ = res else { return }
            guard let data = data else { return }
            
            let img = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
    
    private func ConfigureImage(){
        placeHolder?.withTintColor(.black, renderingMode: .alwaysOriginal)
        image = placeHolder
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

}
