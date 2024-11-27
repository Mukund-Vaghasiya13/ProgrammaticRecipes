//
//  RecipeDetailViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 06/11/24.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipeImage = RRDynamicImageView(style: .roundedRect)
    var headingLable = RRHeadingLabel(fgColor: .gray,alignment: .center, font: 30, text: "null")
    var desc = RRHeadingLabel(fgColor: .gray, alignment: .left, font: 25,text: "Description")
    var bodyLabel = RRBodyLable(text: "", FG: .black, NoOFLine: 5)
    var ingLabel = RRHeadingLabel(fgColor: .gray, alignment: .left, font: 25,text: "Ingredients")
    var ingredients = RRBodyLable(text: "", FG: .black, NoOFLine: 5)
    //var instruction = RRBodyLable(text: "", FG: .black, NoOFLine: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        ConfigureRecipeView()
    }

    func SetRecipeyValue(recipe:Recipe){
        recipeImage.DownloadImage(url: recipe.image ?? "")
        headingLable.text = recipe.title
        bodyLabel.text = recipe.description
        ingredients.text = recipe.ingredients
    }
    
    private func ConfigureRecipeView(){
        view.addSubview(recipeImage)
        view.addSubview(headingLable)
        view.addSubview(desc)
        view.addSubview(ingLabel)
        view.addSubview(bodyLabel)
        view.addSubview(ingredients)
        
        NSLayoutConstraint.activate([
        
            recipeImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            recipeImage.heightAnchor.constraint(equalToConstant: 150),
            recipeImage.widthAnchor.constraint(equalToConstant: 150),
            recipeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            headingLable.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 25),
            headingLable.heightAnchor.constraint(equalToConstant: 33),
            headingLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            desc.topAnchor.constraint(equalTo: headingLable.bottomAnchor, constant: 15),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bodyLabel.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 15),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            ingLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 15),
            ingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            ingredients.topAnchor.constraint(equalTo: ingLabel.bottomAnchor, constant: 15),
            ingredients.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ingredients.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
        ])
    }
}
