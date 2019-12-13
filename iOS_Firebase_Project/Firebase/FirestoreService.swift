//
//  FirestoreService.swift
//  iOS_Firebase_Project
//
//  Created by Alex 6.1 on 11/25/19.
//  Copyright © 2019 aglegaspi. All rights reserved.
//
import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case posts
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest: return true
        }
    }
}


class FirestoreService {
    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    //USERS
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            return
        }
        var updateFields = [String:Any]()
        if let user = userName { updateFields["userName"] = user }
        if let photo = photoURL { updateFields["photoURL"] = photo.absoluteString }
        
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
            if let error = error { completion(.failure(error))
            } else { completion(.success(())) }
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    
    //POSTS
    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = post.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.posts.rawValue).addDocument(data: fields) { (error) in
            if let error = error { completion(.failure(error))
            } else { completion(.success(())) }
        }
    }
    
    private init () {}
}
