//
//  HomeViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import UIKit

class HomeViewController: UIViewController {

    var image = UIImage(systemName: "person.fill")

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
    }
        
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
    @objc func rightBarButtonAction(){
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }

}
