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

    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureNavBar()
        ConfigureViews()
    }
    
    private func ConfigureNavBar(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Recipe"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func ConfigureViews(){
        view.addSubview(ImageView)
        view.addSubview(TitleTextField)
        view.addSubview(discreption)
        ImageView.isUserInteractionEnabled = true
        ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OpenPhotos)))
        
        NSLayoutConstraint.activate([
        
            ImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ImageView.heightAnchor.constraint(equalToConstant: 150),
            ImageView.widthAnchor.constraint(equalToConstant: 150),
            
            TitleTextField.topAnchor.constraint(equalTo: ImageView.bottomAnchor,constant: 10),
            TitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            TitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            TitleTextField.heightAnchor.constraint(equalToConstant: 55),
            
            discreption.topAnchor.constraint(equalTo: TitleTextField.bottomAnchor, constant: 10),
            discreption.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            discreption.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            discreption.heightAnchor.constraint(equalToConstant: 90),
            
        
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

