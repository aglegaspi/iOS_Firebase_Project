//
//  EditProfileVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/15/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos

class EditProfileVC: UIViewController {
    
    //MARK: PROPERTIES
    var user: AppUser!
    var settingFromLogin = false
    var imageURL: URL? = nil
    var image = UIImage() { didSet { self.imageView.image = image } }
    
    
    //MARK: VIEWS
    lazy var imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.backgroundColor = .init(white: 0.2, alpha: 0.9)
         imageView.image = UIImage(systemName: "person")
         imageView.tintColor = .white
         return imageView
     }()

     lazy var addImageButton: UIButton = {
         let button = UIButton()
         button.setTitle("Add Image", for: .normal)
         button.setTitleColor(.white, for: .normal)
          button.titleLabel?.font = button.titleLabel?.font.withSize(34)
         button.backgroundColor = .init(white: 0.2, alpha: 0.9)
         button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
         button.showsTouchWhenHighlighted = true
         return button
     }()

     lazy var userNameTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter User Name"
         textField.autocorrectionType = .no
         textField.textAlignment = .left
         textField.layer.cornerRadius = 15
         textField.backgroundColor = .init(white: 1.0, alpha: 0.2)
         textField.textColor = .white
         textField.borderStyle = .roundedRect
         textField.delegate = self
         return textField
     }()

     lazy var saveButton: UIButton = {
         let button = UIButton()
         button.setTitle("Save Profile", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont(name: "System", size: 14)
         button.backgroundColor = .init(white: 0.2, alpha: 0.9)
         button.showsTouchWhenHighlighted = true
         button.layer.cornerRadius = 5
         button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
         return button
     }()
     
     lazy var cancelButton: UIButton = {
         let button = UIButton()
         button.setTitle("Cancel", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.titleLabel?.font = UIFont(name: "System", size: 14)
         button.backgroundColor = .init(white: 0.2, alpha: 0.9)
         button.layer.cornerRadius = 5

         button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
         return button
     }()
    
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.cornerRadius = (imageView.frame.size.width) / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
    }
    
    
    //MARK: CONSTRAINTS
       private func setupConstraints() {
           setupImageView()
           setupUserNameTextField()
           setupAddImageButton()
           setupSaveButton()
           setupCancelButton()
       }

       private func setupImageView() {
           view.addSubview(imageView)

           imageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
               imageView.heightAnchor.constraint(equalToConstant: 200),
               imageView.widthAnchor.constraint(equalToConstant: 200)
           ])
       }

       private func setupUserNameTextField() {
           view.addSubview(userNameTextField)

           userNameTextField.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               userNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
               userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               userNameTextField.heightAnchor.constraint(equalToConstant: 30),
               userNameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 2)
           ])
       }

       private func setupAddImageButton() {
           view.addSubview(addImageButton)

           addImageButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               addImageButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
               addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               addImageButton.heightAnchor.constraint(equalToConstant: 50),
               addImageButton.widthAnchor.constraint(equalTo: view.widthAnchor)
           ])
       }

       private func setupSaveButton() {
           view.addSubview(saveButton)

           saveButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
               saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
               saveButton.heightAnchor.constraint(equalToConstant: 30),
               saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
           ])
       }
       
       private func setupCancelButton() {
           view.addSubview(cancelButton)

           cancelButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
               cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
               cancelButton.heightAnchor.constraint(equalToConstant: 30),
               cancelButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 3)
           ])
       }
    
    
    //MARK: PRIVATE FUNCTIONS
    private func photoPicker() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }

    private func handleNavigationAwayFromVC() {
        if settingFromLogin {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else { print("cant segue")
                    return }
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = MainTBC()
            }, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: OBJC FUNCTIONS
    @objc private func savePressed(){
        guard let userName = userNameTextField.text, let imageURL = imageURL else {
            showAlert(with: "Failure", and: "Profile Not Updated")
            return
        }
    
        FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
            switch result {
            case .success():
                FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: URL(string: imageURL.absoluteString)) { [weak self] (nextResult) in
                    switch nextResult {
                    case .success(): self?.handleNavigationAwayFromVC()
                    case .failure(let error): print(error)
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    @objc private func cancelButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

    @objc private func addImagePressed() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized: self?.photoPicker()
                case .denied: print("Denied photo library permissions")
                default: print("No usable status")
                }
            })
        default: photoPicker()
        }
    }


}

//MARK: EXTENSIONS
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            present(ShowAlert.showAlert(with: "Error", and: "Couldn't get image"), animated: true, completion: nil)
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            present(ShowAlert.showAlert(with: "Error", and: "Could not compress image"), animated: true, completion: nil)
            return
        }
        FirebaseStorageService.profileManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url): return (self?.imageURL = url)!
            case .failure(let error): print(error)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
