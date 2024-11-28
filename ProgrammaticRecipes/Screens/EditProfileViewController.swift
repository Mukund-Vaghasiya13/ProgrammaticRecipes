//
//  EditProfileViewController.swift
//  ProgrammaticRecipes
//
//  Created by Mukund vaghasiya  on 31/10/24.
//

import UIKit
import PhotosUI


#warning("Fix Body lable hegiht as per content")
class EditProfileViewController: UIViewController {

    var email = RRTextField(with: "Enter Email", is: false)
    var username = RRTextField(with: "Enter Username", is: false)
    var RecipyUserProfile = RRDynamicImageView(style: .roundedRect)
    var updateButton = RRButton(with: "Save Changes", BG: .systemGreen, FG: .white)
    var imagePicker:PHPickerViewController!
    var userAndTokenData:LoginModle!
    var isAvtarChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureView()
        ConfigureOrAddSubViews()
    }
    
    private func ConfigureView(){
        view.backgroundColor = .systemBackground
        navigationItem.title = "Update Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        DismissKeyBord()
    }
    
    private func SetDefaultValue(){
        let userdata = TokenManager.shared.GetTokenDataLocally()
        if let userdata = userdata{
            email.text = userdata.user.email
            username.text = userdata.user.username
            RecipyUserProfile.DownloadImage(url: userdata.user.profilePicture ?? "")
            userAndTokenData = userdata
        }else{
            //Show Error And Dissmiss View
            print("User Token Or Local data not found")
        }
    }
    
    private func ConfigureOrAddSubViews(){
        SetDefaultValue()
        view.addSubview(RecipyUserProfile)
        view.addSubview(email)
        view.addSubview(username)
        view.addSubview(updateButton)
        
        NSLayoutConstraint.activate([
        
        
            RecipyUserProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            RecipyUserProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            RecipyUserProfile.heightAnchor.constraint(equalToConstant: 150),
            RecipyUserProfile.widthAnchor.constraint(equalToConstant: 150),
        
            email.topAnchor.constraint(equalTo: RecipyUserProfile.bottomAnchor, constant: 10),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            email.heightAnchor.constraint(equalToConstant: 55),
    
            username.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            username.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            username.heightAnchor.constraint(equalToConstant: 55),
            
            updateButton.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            updateButton.heightAnchor.constraint(equalToConstant: 55),
        
        ])
        
        RecipyUserProfile.isUserInteractionEnabled = true
        RecipyUserProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OpenPhotos)))
        
        updateButton.addTarget(self, action: #selector(UplodeData), for: .touchUpInside)
    }
    
     @objc func UplodeData(){
        
        let token = TokenManager.shared.GetToken()
        
        let header = [
            "Authorization":"Bearer \(token ?? "")"
        ]

         var JPEGData:ImageRequest?
         
         if isAvtarChanged {
             guard let imageData = RecipyUserProfile.image?.jpegData(compressionQuality: 0.8) else{
                 //TODO: alert or message
                 print("\n\n Image Data")
                 self.ShowAlert(message:"please Uplode Image", title:"Image Required")
                 return
             }
             JPEGData = ImageRequest(attachment: imageData, fileName: "RecipyUserProfile")
         }
         
         let fields = [
             "username":username.text ?? "",
             "email":email.text ?? ""
         ]
         let imageAndField = Payload(imageData: JPEGData, fields: fields)
         
        NetworkHandler.shared.MultiparFormRequest(for: User.self, endpoint: "http://localhost:3000/api/v1/User/update", headers: header, payload: imageAndField) { res in
            switch res {
            case .success(let success):
                print(success)
                if var userAndTokenData = self.userAndTokenData{
                    TokenManager.shared.LogoutDeleteToken()
                    userAndTokenData.user = success
                    TokenManager.shared.SetTokenDataLocally(loginData: userAndTokenData)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let failure):
                DispatchQueue.main.async{
                    self.ShowAlert(message: failure.technicalDetails ?? "Oops Something went wrong", title: failure.message ?? "")
                }
            }
        }
    }
    
    @objc func OpenPhotos(){
        var configure = PHPickerConfiguration()
        configure.selectionLimit = 1
        configure.filter = .images
        imagePicker = PHPickerViewController(configuration: configure)
        imagePicker.delegate = self
        navigationController?.present(imagePicker, animated: true)
    }
}


extension EditProfileViewController:PHPickerViewControllerDelegate {
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
                    self.RecipyUserProfile.image = image
                    self.isAvtarChanged = true
                }
            }
        }
    }
}
