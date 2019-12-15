//
//  ProfileVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import UIKit
import FirebaseAuth


class ProfileVC: UIViewController {
    
    //MARK: PROPERTIES
    var user: AppUser!
    var isCurrentUser = false
    var imageURL: String? = nil
    var image = UIImage() { didSet { self.profileImage.image = image } }
    var posts = [Post]() { didSet { self.postCount = self.posts.count } }
    var postCount = 0 {
        didSet {
            totalPost.text = "You have a total of \(postCount) Posts"
        }
    }
    
    //MARK: VIEWS
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    lazy var totalPost: UILabel = {
        let label = UILabel()
        label.text = "0 \n Posts"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .init(white: 0.4, alpha: 0.8)
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return button
    }()
    
    lazy var logOutButton: UIButton = {
        var button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchDown)
        return button
    }()
    
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.000, green: 0.755, blue: 1.000, alpha: 1.0)
        setConstraints()
        getPostCount()
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        getPostCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPostCount()
        setUserName()
    }
    
    //MARK: PRIVATE FUNCTIONS
    private func setUserName() {
        if let displayName = FirebaseAuthService.manager.currentUser?.displayName {
            userName.text = displayName
        }
    }
    
    private func setProfileImage() {
        if let pictureUrl = FirebaseAuthService.manager.currentUser?.photoURL {
            FirebaseStorageService.profileManager.getUserImage(photoUrl: pictureUrl) { (result) in
                switch result {
                case .failure(let error): print(error)
                case .success(let image): self.profileImage.image = image
                }
            }
        }
    }
    
    private func getPostCount() {
        if let userUID = FirebaseAuthService.manager.currentUser?.uid {
            DispatchQueue.global(qos: .default).async {
                FirestoreService.manager.getPosts(forUserID: userUID) { (result) in
                    switch result {
                    case .failure(let error): print(error)
                    case .success(let posts):
                        if posts.count > self.postCount { self.getUserPosts() }
                        self.postCount = posts.count
                    }
                }
            }
        }
    }
    
    private func getUserPosts() {
        if let userUID =  FirebaseAuthService.manager.currentUser?.uid {
            FirestoreService.manager.getPosts(forUserID: userUID, completion: { (result) in
                switch result {
                case .failure(let error): print(error)
                case .success(let postsFromFirebase):
                    DispatchQueue.main.async { self.posts = postsFromFirebase }
                }
            })
        }
    }
    
    
    //MARK: CONSTRAINTS
    private func setConstraints() {
        constrainProfileImage()
        constrainUserName()
        constrainTotalPosts()
        constrainEditButton()
        setUserName()
        setProfileImage()
        constrainLogOutButton()
    }
    
    private func constrainProfileImage() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 100),
            profileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 300),
            profileImage.heightAnchor.constraint(equalToConstant: 300)])
    }
    
    private func constrainUserName() {
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            userName.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userName.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: 1.5),
            userName.heightAnchor.constraint(equalToConstant: 70)])
    }
    
    private func constrainTotalPosts() {
        view.addSubview(totalPost)
        totalPost.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPost.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            totalPost.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            totalPost.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: 1.5),
            totalPost.heightAnchor.constraint(equalToConstant: 70)
        ])
        
    }
    
    private func constrainEditButton() {
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: totalPost.bottomAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    private func constrainLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logOutButton.heightAnchor.constraint(equalToConstant: 30),
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
            
        ])
    }
    
    
    //MARK: OBJC FUNCTIONS
    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
            present(ShowAlert.showAlert(with: "Signed Out!", and: "See You Soon."), animated: true, completion: nil)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else { return }
            
            UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = {
                    let loginVC = LoginVC()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                    return loginVC
                }()
            }, completion: nil)
            
        } catch {
            print(error)
        }
    }
    
    @objc private func editAction(){
        let editVC = EditProfileVC()
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: true, completion: nil)
    }
    
}




