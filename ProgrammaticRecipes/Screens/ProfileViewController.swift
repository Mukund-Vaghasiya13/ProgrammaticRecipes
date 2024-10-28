//
//  ProfileViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/10/24.
//

import UIKit

class ProfileViewController: UIViewController {

    private var locallyData:LoginModle!
    var imageView = RRImage(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadLocallyData()
        ConfigureNavBar()
        ConfigureView()
    }

    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = locallyData?.user.username ?? ""
    }
    
    private func LoadLocallyData(){
        let data = TokenManager.shared.GetTokenDataLocally()
        if let data = data{
            locallyData = data
        }
    }
    
    private func ConfigureView(){
        view.addSubview(imageView)
        imageView.DownloadImage(url: locallyData.user.profilePicture ?? "")
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }

 

}
