//
//  HomeViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 26/10/24.
//

import UIKit

class HomeViewController: UIViewController {

    enum Section{
        case Main
    }
    
    var image = UIImage(systemName: "person.fill")
    var recipes:[Recipe] = []
    var dataSource:UITableViewDiffableDataSource<Section,Recipe>!
    var TableView:UITableView!
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        LoadListOfRecipes(page: page)
        ConfigureTableView()
        ConfigureDataSource()
    }
    
    func LoadListOfRecipes(page:Int){
        let endpoint = "http://localhost:3000/api/v1/Recipe/list?page=\(page)"
        let token = TokenManager.shared.GetToken()
        let header = [
            "Authorization":"Bearer \(token ?? "")"
        ]
        
        NetworkHandler.shared.GetRequest(for: [Recipe].self, endpoint: endpoint, headers: header) { res in
            DispatchQueue.main.async {
                self.TableView.refreshControl?.endRefreshing()
            }
            switch res {
            case .success(let success):
                self.recipes = success
                self.UpdateData()
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
    
    private func ConfigureTableView(){
        TableView = UITableView(frame: view.frame,style: .plain)
        view.addSubview(TableView)
        TableView.register(RecipeListCellTableViewCell.self, forCellReuseIdentifier: RecipeListCellTableViewCell.reUseId)
        TableView.rowHeight = 250
        TableView.showsVerticalScrollIndicator = false
        
        
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(ReloadData), for: .valueChanged)
        TableView.refreshControl = refreshView
    }
    
    
    @objc func ReloadData(){
        if recipes.count ==  10 { page += 1}
        LoadListOfRecipes(page: self.page)
    }
    
    private func ConfigureDataSource(){
        dataSource = UITableViewDiffableDataSource(tableView: TableView, cellProvider: { tableView, indexPath, recipe in
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListCellTableViewCell.reUseId, for: indexPath) as? RecipeListCellTableViewCell
            cell?.Set(ImageUrl: recipe.image, des: recipe.description)
            return cell
        })
    }
    
    private func UpdateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Recipe>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(recipes)
        DispatchQueue.main.async{
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
        
    }
    
    @objc func rightBarButtonAction(){
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }

}
