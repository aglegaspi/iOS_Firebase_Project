//
//  FeedCell.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/11/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    var postImage: UIImageView = {
        let image = UIImageView()
        //image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        return image
    }()
        
    var infoView: UIView = {
        let view = UIView()
        //view.backgroundColor = .init(white: 0.3, alpha: 0.8)
        return view
    }()
        
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        //image.backgroundColor = .lightGray
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageConstraints()
        setInfoViewConstraints()
        setProfileImageConstraints()
        setNameConstraints()
    }
    
    override func layoutSubviews() {
        profileImage.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = CGColor.init(srgbRed: 1.0, green: 1.0, blue: 1.00, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setImageConstraints() {
        contentView.addSubview(postImage)
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImage.widthAnchor.constraint(equalToConstant: postImage.frame.width),
            postImage.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100)])
        }

        func setProfileImageConstraints() {
            infoView.addSubview(profileImage)
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
            profileImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)])
        }
        
        func setNameConstraints() {
               infoView.addSubview(nameLabel)
               nameLabel.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: -20),
                nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
                nameLabel.heightAnchor.constraint(equalTo: infoView.heightAnchor)])
           }
           
        func setInfoViewConstraints(){
            contentView.addSubview(infoView)
            infoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: postImage.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: postImage.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 100)])
        }
        
}
