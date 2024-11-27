//
//  RRImage.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/10/24.
//

import UIKit


enum CoustomImageStyle{
    case rounded
    case roundedRect
    case rect
}

class RRDynamicImageView: UIImageView {
    
    private var placeHolder = UIImage(systemName: "person.fill")
    private var imageStyle = CoustomImageStyle.rect
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ConfigureImage()
    }
    
    init(style:CoustomImageStyle){
        super.init(frame: .zero)
        imageStyle = style
        ConfigureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DownloadImage(url:String){
        
        let nssURL = NSString(string: url)
        if let image = NetworkHandler.shared.chache.object(forKey: nssURL){
            self.image = image
        }else{
            guard let url = URL(string: url) else{ return }
            URLSession.shared.dataTask(with:url) { data, res, err in
                if err != nil { return }
                guard let _ = res else { return }
                guard let data = data else { return }
                
                if let img = UIImage(data: data) {
                    NetworkHandler.shared.chache.setObject(img, forKey: nssURL)
                    DispatchQueue.main.async {
                        self.image = img
                    }
                }
            }.resume()
        }
    }
    
    private func ConfigureImage(){
        placeHolder?.withTintColor(.black, renderingMode: .alwaysOriginal)
        image = placeHolder
        translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageStyle == .rounded {
            layer.cornerRadius = frame.size.width / 2
        } else if imageStyle  == .roundedRect{
            layer.cornerRadius = 10
        }
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

}
