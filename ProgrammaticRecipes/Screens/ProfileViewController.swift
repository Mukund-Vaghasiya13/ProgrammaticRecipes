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
    var recipes:[Recipe] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadLocallyData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        ConfigureView()
        ConfigureDataSource()
        LoadListOfRecipes(page: 1)
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
    
    private func ConfigureDataSource(){
        dataSources = UICollectionViewDiffableDataSource(collectionView: recipesCollection, cellProvider: { [self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserRecipeItem.id, for: indexPath) as? UserRecipeItem
            cell?.SetImage(url: recipes[indexPath.row].image ?? "")
            return cell
        })
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
        
        recipesCollection.register(UserRecipeItem.self, forCellWithReuseIdentifier: UserRecipeItem.id)
        recipesCollection.delegate = self
        
    }
    
    private func CollectionViewLyout()->UICollectionViewFlowLayout{
        
        let padding:CGFloat  = 12
        let itemSpacing:CGFloat = 5
        let fullwidht = view.bounds.width
        let avalableSpace = fullwidht - ( 2 * padding ) - ( 2 * itemSpacing )
        let itemWidth = avalableSpace / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        flowLayout.minimumInteritemSpacing = itemSpacing
        return flowLayout
    }
    
    func LoadListOfRecipes(page:Int){
        let endpoint = "http://localhost:3000/api/v1/Recipe/list/user?page=\(page)"
        let token = TokenManager.shared.GetToken()
        let header = [
            "Authorization":"Bearer \(token ?? "")"
        ]
        
        NetworkHandler.shared.GetRequest(for: [Recipe].self, endpoint: endpoint, headers: header) { res in
            switch res {
            case .success(let success):
                self.recipes = success
                self.updateData()
                break
            case .failure(let failure):
                self.ShowAlert(message: failure.technicalDetails ?? "System Filuare", title: failure.message ?? "Oops!")
            }
        }
    }
    
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Recipe>()
        snapshot.appendSections([Section.Main])
        snapshot.appendItems(recipes)
        DispatchQueue.main.async{
            self.dataSources.apply(snapshot,animatingDifferences: true)
        }
    }
    
    
    @objc func EditButtonAction(){
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    @objc func AddButtonAction(){
        navigationController?.pushViewController(AddRecipesViewController(), animated: true)
    }
}

extension ProfileViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert  = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Delete", style: .destructive) { act in
            print("Hello")
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
