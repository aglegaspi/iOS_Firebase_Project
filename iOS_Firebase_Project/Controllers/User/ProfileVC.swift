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
    
    lazy var logOutButton: UIButton = {
        var button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.000, green: 0.755, blue: 1.000, alpha: 1.0)
        constrainLogOutButton()
    }
    
    private func constrainLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logOutButton.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width / 2),
            logOutButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
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
    
}
