//
//  HomeViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
    }
    
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        //Debug
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        //Debug
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(rightBarButtonAction))
        
    }
    
    @objc func rightBarButtonAction(){
        TokenManager.shared.LogoutDeleteToken()
        navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
