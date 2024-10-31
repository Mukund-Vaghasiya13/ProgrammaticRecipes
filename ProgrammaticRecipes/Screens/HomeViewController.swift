//
//  HomeViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import UIKit

class HomeViewController: UIViewController {

    var image = UIImage(systemName: "person.fill")
    var recipes:[Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        LoadListOfRecipes()
    }
    
    func LoadListOfRecipes(){
        let endpoint = "http://localhost:3000/api/v1/Recipe/list?page=1"
        let token = TokenManager.shared.GetToken()
        let header = [
            "Authorization":"Bearer \(token ?? "")"
        ]
        
        NetworkHandler.shared.GetRequest(for: [Recipe].self, endpoint: endpoint, headers: header) { res in
            switch res {
            case .success(let success):
                print(success)
                break
            case .failure(let failure):
                print(failure)
            }
        }
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
