//
//  AddRecipesViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 31/10/24.
//

import UIKit
import PhotosUI


class AddRecipesViewController: UIViewController {
    
    var ImageView  = RRRecipeImageView(frame: .zero)
    var imagePicker:PHPickerViewController!
    var TitleTextField = RRTextField(with: "Enter Title", is: false)
    var discreption = RRTextArea(placeholder: "Enter Discreption")
    var ingredients = RRTextArea(placeholder: "Enter Ingredients")
    var instructions = RRTextArea(placeholder: "Enter Instructions")
    var UplodeButton = RRButton(with: "Create Recipe", BG: .systemGreen, FG: .white)
    var scrollview = UIScrollView()
    var ContentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        ConfigureSubViewS()
    }
    
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Recipe"
        navigationController?.navigationBar.prefersLargeTitles = true
        DismissKeyBord()
    }
    
    private func ConfigureSubViewS(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.addSubview(ContentView)
        ContentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(ImageView)
        view.addSubview(TitleTextField)
        view.addSubview(discreption)
        view.addSubview(ingredients)
        view.addSubview(instructions)
        view.addSubview(UplodeButton)
        
        ImageView.isUserInteractionEnabled = true
        ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OpenPhotos)))
        
        NSLayoutConstraint.activate([
        
            scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            ContentView.topAnchor.constraint(equalTo: scrollview.topAnchor),
            ContentView.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            ContentView.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            ContentView.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            ContentView.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            ContentView.heightAnchor.constraint(equalTo:scrollview.heightAnchor,multiplier: 1.02),
            
            ImageView.topAnchor.constraint(equalTo: ContentView.topAnchor, constant: 20),
            ImageView.centerXAnchor.constraint(equalTo: ContentView.centerXAnchor),
            ImageView.heightAnchor.constraint(equalToConstant: 150),
            ImageView.widthAnchor.constraint(equalToConstant: 150),
            
            TitleTextField.topAnchor.constraint(equalTo: ImageView.bottomAnchor,constant: 10),
            TitleTextField.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
            TitleTextField.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            TitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            discreption.topAnchor.constraint(equalTo: TitleTextField.bottomAnchor, constant: 10),
            discreption.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
            discreption.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            discreption.heightAnchor.constraint(equalToConstant: 85),
            
            ingredients.topAnchor.constraint(equalTo: discreption.bottomAnchor, constant: 10),
            ingredients.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
            ingredients.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            ingredients.heightAnchor.constraint(equalToConstant: 85),
            
            instructions.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 10),
            instructions.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
            instructions.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            instructions.heightAnchor.constraint(equalToConstant: 85),
            
            UplodeButton.topAnchor.constraint(equalTo: instructions.bottomAnchor,constant: 10),
            UplodeButton.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
            UplodeButton.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            UplodeButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        
        ])
    }
    
    private func ConfigureViews(){
        view.addSubview(ImageView)
        view.addSubview(TitleTextField)
        view.addSubview(discreption)
        view.addSubview(ingredients)
        view.addSubview(instructions)
        view.addSubview(UplodeButton)
        
        
        NSLayoutConstraint.activate([
        
            ImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ImageView.heightAnchor.constraint(equalToConstant: 90),
            ImageView.widthAnchor.constraint(equalToConstant: 90),
            
            
            
           
          
        
        ])
    }
    
    // MARK: Perfect!!
    @objc func OpenPhotos(){
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 1
        configure.filter = .images
        imagePicker = PHPickerViewController(configuration: configure)
        imagePicker.delegate = self
        navigationController?.present(imagePicker, animated: true)
    }
}

extension AddRecipesViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let firstResult = results.first else {
            return
        }
        
        if firstResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                
                guard let self = self, let image = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.ImageView.image = image
                }
            }
        }
    }
}

