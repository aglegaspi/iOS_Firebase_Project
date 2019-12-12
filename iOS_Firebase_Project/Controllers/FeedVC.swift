//
//  FeedVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    var feed = "" {
        didSet { collectionView.reloadData() }
    }
    
    lazy var collectionView: UICollectionView = {
        var cv = UICollectionView()
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.000, green: 0.755, blue: 0.000, alpha: 1.0)
    }
    
}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
