//
//  MainTBC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {
    lazy var feedVC = UINavigationController(rootViewController: FeedVC())
    lazy var uploadVC = UINavigationController(rootViewController: UploadVC())
    
    lazy var profileVC: UINavigationController = {
        let userProfileVC = ProfileVC()
        return UINavigationController(rootViewController: userProfileVC)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedVC.isNavigationBarHidden = true
        uploadVC.isNavigationBarHidden = true
        profileVC.isNavigationBarHidden = true

        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.dash"), tag: 0)
        uploadVC.tabBarItem = UITabBarItem(title: "Upload", image: UIImage(systemName: "photo"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 2)
        self.viewControllers = [feedVC, uploadVC, profileVC]
        self.viewControllers?.forEach({$0.tabBarController?.tabBar.barStyle = .default})
    }
}
