//
//  FeedVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//
import UIKit

class FeedVC: UIViewController {
    
    //MARK: PROPERTIES
    var posts = [Post]() { didSet { collectionView.reloadData() } }
    
    //MARK: VIEWS
    var projectLabel: UILabel = {
        let label = UILabel()
        label.text = "The Feed"
        label.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(red: 1.000, green: 0.755, blue: 0.000, alpha: 1.0)
        collection.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        return collection
    }()
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.000, green: 0.755, blue: 0.000, alpha: 1.0)
        setUpConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadPosts()
        //self.posts = [Post(photoUrl: "", creatorID: "Hello There", dateCreated: Date()), Post(photoUrl: "", creatorID: "Hello There", dateCreated: Date()), Post(photoUrl: "", creatorID: "Hello There", dateCreated: Date())]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadPosts()
    }
    
    //MARK: CONSTRAINTS
    private func setUpConstraints() {
        constrainLabel()
        constrainCollectionView()
    }
    
    private func constrainLabel() {
        view.addSubview(projectLabel)
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            projectLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectLabel.heightAnchor.constraint(equalToConstant: 50),
            projectLabel.widthAnchor.constraint(equalTo: view.widthAnchor)])
    }
    
    private func constrainCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: projectLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    //MARK: PRIVATE FUNCTIONS
    private func loadPosts() {
        FirestoreService.manager.getAllPosts(sortingCriteria: nil) { (result) in
            switch result {
            case .failure(let error):
                self.present(ShowAlert.showAlert(with: "Error", and: "Could not load posts: \(error)"), animated: true, completion: nil)
            case .success(let postsFromFirebase):
                self.posts = postsFromFirebase
            }
        }
    }
}

//MARK: EXTENSION
extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        let imageURL = post.photoUrl ?? ""
        cell.nameLabel.text = post.creatorID
        
        if let image = ImageHelper.shared.image(forKey: imageURL as NSString) {
            cell.postImage.image = image
        } else {
            ImageHelper.shared.getImage(urlStr: imageURL) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error): print(error)
                    case .success(let image): cell.postImage.image = image
                    }
                }
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PhotoDetailVC()
        present(detailVC, animated: true, completion: nil)
    }
    
}
