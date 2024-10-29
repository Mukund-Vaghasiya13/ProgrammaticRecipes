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
    var bodyLable = RRBodyLable(text: "", FG: .systemGray)
    var satck = UIStackView()
    var editButton = RRButton(with: "Edit Profile", BG: .black, FG: .white)
    var AddButton = RRButton(with: "Add Recipe", BG: .black, FG: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadLocallyData()
        ConfigureNavBar()
        ConfigureView()
    }

    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = locallyData?.user.username ?? ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(Logout))
    }
    
    @objc func Logout(){
        TokenManager.shared.LogoutDeleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func LoadLocallyData(){
        let data = TokenManager.shared.GetTokenDataLocally()
        if let data = data{
            locallyData = data
        }
    }
    
    private func ConfigureView(){
        view.addSubview(imageView)
        view.addSubview(bodyLable)
        view.addSubview(satck)
        
        satck.translatesAutoresizingMaskIntoConstraints = false
        bodyLable.text = locallyData.user.email
        imageView.DownloadImage(url: locallyData.user.profilePicture ?? "")
        
        satck.alignment = .fill   // Make buttons fill the stack view's height
        satck.distribution = .fillEqually  // Evenly space buttons
        satck.spacing = 10
        
        satck.addArrangedSubview(editButton)
        satck.addArrangedSubview(AddButton)
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            
            bodyLable.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 5),
            bodyLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bodyLable.heightAnchor.constraint(equalToConstant: 20),
            
            satck.topAnchor.constraint(equalTo: bodyLable.bottomAnchor, constant: 10),
            satck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            satck.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            satck.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
}
