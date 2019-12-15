//
//  FirebaseAuthService.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 11/25/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let manager = FirebaseAuthService()
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<User,Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let createdUser = result?.user {
                completion(.success(createdUser))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
        func updateUserFields(userName: String? = nil,photoURL: URL? = nil, completion: @escaping (Result<(),Error>) -> ()) {
            let changeRequest = auth.currentUser?.createProfileChangeRequest()
    
            if let userName = userName {
                changeRequest?.displayName = userName
            }
            if let photoURL = photoURL {
                changeRequest?.photoURL = photoURL
            }
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
        }
    
    func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
            if let name = name{
                request.displayName = name
            }
            if let url = photoUrl{
                request.photoURL = url
            }
            
            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<(), Error>) -> ()) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            
            if let _ = result?.user {
                completion(.success(()))
            } else if let error = error { completion(.failure(error)) }
        }
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    private init () {}
}
