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
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageConstraints()
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
        
}
