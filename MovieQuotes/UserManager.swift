//
//  UserManager.swift
//  MovieQuotes
//
//  Created by Hanyu Yang on 2021/1/24.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"
let kKeyPhotoUrl = "photoUrl"

class UserManager {
    
    var _userCollectionRef: CollectionReference
    var _document: DocumentSnapshot?
    var _userListener: ListenerRegistration?
    
    static let shared = UserManager()
    
    private init() {
        _userCollectionRef = Firestore.firestore().collection(kCollectionUsers)
    }
    
    func addNewUserMabye(uid: String, name: String?, photoUrl: String?) {
        let userRef = _userCollectionRef.document(uid)
        userRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting user: \(error)")
            }
            if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("There is already a User Object for this auth user. DO NOTHING.")
                } else {
                    print("Creating a User with Document id \(uid)")
                    userRef.setData([
                        kKeyName: name ?? "",
                        kKeyPhotoUrl: photoUrl ?? ""
                    ])
                }
            }
        }
    }
    
    func beginListening(uid: String, changeListener: (() -> Void)?) {
        stopListening()
        let userRef = _userCollectionRef.document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error listening for user \(error)")
                return
            }
            if let documentSnapshot = documentSnapshot {
                self._document = documentSnapshot
                changeListener?()
            }
        }
    }
    
    func stopListening() {
        _userListener?.remove()
    }
    
    func updateName(name: String) {
        let userRef = _userCollectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyName: name
        ])
    }
    
    func updatePhotoUrl(photoUrl: String) {
        let userRef = _userCollectionRef.document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            kKeyPhotoUrl: photoUrl
        ])
    }
    
    var name: String {
        if let value = _document?.get(kKeyName) {
            return value as! String
        }
        return ""
    }
    
    var photoUrl: String {
        if let value = _document?.get(kKeyPhotoUrl) {
            return value as! String
        }
        return ""
    }
    
    
}
