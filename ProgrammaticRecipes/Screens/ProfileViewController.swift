//
//  ProfileViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 28/10/24.
//

import UIKit

class ProfileViewController: UIViewController {

    enum Section{
        case Main
    }
    
    private var locallyData:LoginModle!
    var imageView = RRDynamicImageView(style: .rounded)
    var bodyLable = RRBodyLable(text: "", FG: .systemGray,NoOFLine: 1)
    var satck = UIStackView()
    var editButton = RRButton(with: "Edit Profile", BG: .black, FG: .white)
    var AddButton = RRButton(with: "Add Recipe", BG: .black, FG: .white)
    var recipesCollection:UICollectionView!
    var dataSources:UICollectionViewDiffableDataSource<Section,Recipe>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadLocallyData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        ConfigureView()
    }
    

    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(Logout))
    }
    
    @objc func Logout(){
        TokenManager.shared.LogoutDeleteToken()
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func LoadLocallyData(){
        let data = TokenManager.shared.GetTokenDataLocally()
        if let data = data{
            navigationItem.title = data.user.username ?? ""
            bodyLable.text = data.user.email
            imageView.DownloadImage(url:data.user.profilePicture ?? "")
        }
    }
    
    private func ConfigureView(){
        view.addSubview(imageView)
        view.addSubview(bodyLable)
        view.addSubview(satck)
        
        satck.translatesAutoresizingMaskIntoConstraints = false
        satck.alignment = .fill   // Make buttons fill the stack view's height
        satck.distribution = .fillEqually  // Evenly space buttons
        satck.spacing = 10
        
        satck.addArrangedSubview(editButton)
        satck.addArrangedSubview(AddButton)
        
        editButton.addTarget(self, action: #selector(EditButtonAction), for: .touchUpInside)
        AddButton.addTarget(self, action: #selector(AddButtonAction), for: .touchUpInside)
        
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
        
        ConfigureCollectionView()
    }
    
    private func ConfigureCollectionView(){
        recipesCollection = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLyout())
        recipesCollection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recipesCollection)
        
        NSLayoutConstraint.activate([
        
            recipesCollection.topAnchor.constraint(equalTo: satck.bottomAnchor, constant: 15),
            recipesCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        ])
        #error("TODO: Create collection View Cell")
    }
    
    private func CollectionViewLyout()->UICollectionViewFlowLayout{
        
        let padding:CGFloat  = 12
        let itemSpacing:CGFloat = 10
        let fullwidht = view.bounds.width
        let avalableSpace = fullwidht - ( 2 * padding ) - ( 2 * itemSpacing )
        let itemWidth = avalableSpace / 3
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowLayout
    }
    
    
    @objc func EditButtonAction(){
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    @objc func AddButtonAction(){
        navigationController?.pushViewController(AddRecipesViewController(), animated: true)
    }
}
