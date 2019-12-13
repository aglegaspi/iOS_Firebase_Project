//
//  UploadVC.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 12/12/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//
import UIKit

class UploadVC: UIViewController {

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
    
    var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(34)
        button.backgroundColor = .blue
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        //button.backgroundColor = .yellow
        button.showsTouchWhenHighlighted = true
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

}
