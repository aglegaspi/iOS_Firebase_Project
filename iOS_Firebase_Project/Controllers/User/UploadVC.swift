//
//  UploadVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//
import UIKit
import Photos

class UploadVC: UIViewController {

//MARK: PROPERTIES
    var image = UIImage() { didSet { self.uploadImageView.image = image } }
    var imageURL: URL? = nil
    
//MARK: VIEWS
    var uploadLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Upload An Image"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    var uploadImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "uploadImage")
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.5)
        button.addTarget(self, action: #selector(addImage), for: .touchDown)
        return button
    }()
    
    var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(uploadPost), for: .touchDown)
        return button
    }()
    
   
//MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 0.755, blue: 1.0, alpha: 1.0)
        setUpConstraints()
    }
   
//MARK: CONSTRAINTS
    private func setUpConstraints() {
        setUploadLabelConstraints()
        setUploadImageConstraints()
        setUploadButtonConstraints()
        setAddButtonConstraints()
    }
    private func setUploadLabelConstraints() {
        view.addSubview(uploadLabel)
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            uploadLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            uploadLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)])
    }
    private func setUploadImageConstraints() {
        view.addSubview(uploadImageView)
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 100),
            uploadImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 300),
            uploadImageView.heightAnchor.constraint(equalToConstant: 300)])
    }
    private func setUploadButtonConstraints() {
        view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            uploadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uploadButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: 1.5),
            uploadButton.heightAnchor.constraint(equalToConstant: 70)])
    }
    private func setAddButtonConstraints() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: uploadImageView.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 40)])
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
    
//MARK: OBJC FUNCTIONS
    // PICK AN IMAGE
    @objc func addImage() {
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
    
    //UPLOAD AN IMAGE
    @objc func uploadPost() {
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        guard let photoUrl = imageURL else {return}
        FirestoreService.manager.createPost(post: Post(photoUrl: photoUrl.absoluteString, creatorID: user.uid)) { (result) in
            switch result {
            case .failure(let error):
                self.present(ShowAlert.showAlert(with: "Could not make post", and: "Error: \(error)"), animated: true, completion: nil)
            case .success:
                self.present(ShowAlert.showAlert(with: "Success", and: "Post created"), animated: true, completion: nil)
                self.uploadImageView.image = nil
                self.view.layoutSubviews()
            }
        }
    }

}

extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        FirebaseStorageService.manager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url): return (self?.imageURL = url)!
            case .failure(let error): print(error)
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
}

