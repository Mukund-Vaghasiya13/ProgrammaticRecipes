//
//  AddRecipesViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 31/10/24.
//

import UIKit
import PhotosUI


// TODO: Network Call : http://localhost:3000/api/v1/Recipe/createRecipes

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
       
        ScrollViewAndContentView()
        
        ContentView.addSubview(ImageView)
        ViewHandler()
        
        ImageView.isUserInteractionEnabled = true
        ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OpenPhotos)))
        
        NSLayoutConstraint.activate([
    
            ImageView.topAnchor.constraint(equalTo: ContentView.topAnchor, constant: 20),
            ImageView.centerXAnchor.constraint(equalTo: ContentView.centerXAnchor),
            ImageView.heightAnchor.constraint(equalToConstant: 150),
            ImageView.widthAnchor.constraint(equalToConstant: 150),
            
            TitleTextField.topAnchor.constraint(equalTo: ImageView.bottomAnchor,constant: 10),
            TitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            discreption.topAnchor.constraint(equalTo: TitleTextField.bottomAnchor, constant: 10),
            discreption.heightAnchor.constraint(equalToConstant: 85),
            
            ingredients.topAnchor.constraint(equalTo: discreption.bottomAnchor, constant: 10),
            ingredients.heightAnchor.constraint(equalToConstant: 85),
            
            instructions.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 10),
            instructions.heightAnchor.constraint(equalToConstant: 85),
            
            UplodeButton.topAnchor.constraint(equalTo: instructions.bottomAnchor,constant: 10),
            UplodeButton.heightAnchor.constraint(equalToConstant: 50),
        
        ])
        
        UplodeButton.addTarget(self, action: #selector(UplodeData), for: .touchUpInside)
    }
    
    
    @objc func UplodeData(){
        let token = TokenManager.shared.GetToken()
        
        let header = [
            "Authorization":"Bearer \(token ?? "")"
        ]
        
        guard let imageData = ImageView.image?.jpegData(compressionQuality: 0.8) else{
            //TODO: alert or message
            print("\n\n Image Data")
            self.ShowAlert(message:"please Uplode Image", title:"Image Required")
            return
        }
        
        let JPEGData = ImageRequest(attachment: imageData, fileName: "RecipesImage")
        
        //TODO: Fields Validation
        
        let fields = [
            "title":TitleTextField.text ?? "",
            "description":discreption.text ?? "",
            "ingredients":ingredients.text ?? "",
            "instructions":instructions.text ?? ""
        ]
        
        let imageAndField = Payload(imageData: JPEGData, fields: fields)
        
        NetworkHandler.shared.MultiparFormRequest(for: Recipe.self, endpoint: "http://localhost:3000/api/v1/Recipe/createRecipes", headers: header, payload: imageAndField) { res in
            switch res {
            case .success(let success):
                //MARK: To Do Something 
                print(success)
            case .failure(let failure):
                DispatchQueue.main.async{
                    self.ShowAlert(message: failure.technicalDetails ?? "Oops Something went wrong", title: failure.message ?? "")
                }
            }
        }
        
    }
    
    private func ScrollViewAndContentView(){
        view.addSubview(scrollview)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.addSubview(ContentView)
        ContentView.translatesAutoresizingMaskIntoConstraints = false
        
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
            ContentView.heightAnchor.constraint(equalTo:scrollview.heightAnchor,multiplier: 1.35),
    
        ])
        
        
    }
    
    
    private func ViewHandler(){
        let listOfView = [TitleTextField,discreption,ingredients,instructions,UplodeButton]
        
        for i in listOfView{
            ContentView.addSubview(i)
            ContentView.addSubview(i)
            ContentView.addSubview(i)
            ContentView.addSubview(i)
            ContentView.addSubview(i)
            
            NSLayoutConstraint.activate([
                i.leadingAnchor.constraint(equalTo: ContentView.leadingAnchor, constant: 30),
                i.trailingAnchor.constraint(equalTo: ContentView.trailingAnchor, constant: -30),
            ])
        }
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

