//
//  FirebaseDatabaseConstants.swift
//  God is Love
//
//  Created by Corey Edh on 12/31/22.
//

import Foundation
import Firebase


enum Collection{
   
   case PrayerCollection(documentID: String? = nil)
   case UserCollection(UserDocument)
   
   var documentReference: DocumentReference{
       let db = Firebase.Firestore.firestore()
       switch self {
       case .PrayerCollection(let documentID):
           if let documentID = documentID{
               return db.collection("Prayers").document(documentID)
           }else{
               return db.collection("Prayers").document()
           }
       case .UserCollection(let UserDocument):
           return UserDocument.documentReference
       }
   }
    
    var collectionReference: CollectionReference{
        let db = Firebase.Firestore.firestore()
        switch self{
            case .PrayerCollection(_):
                return db.collection("Prayers")
            case .UserCollection(_):
                return db.collection("Users")
        }
    }
    
    enum UserDocument{
        private var db : CollectionReference{ return Firebase.Firestore.firestore().collection("Users") }

        case User(User)
        case Friend(User, documentID: String? = nil)
        case Prayer(User, documentID: String? = nil)
        
        var userCollectionReference: CollectionReference{
            switch self{
            case .User(_):
                return db
            case .Friend(let user, _):
                return db.document(user.uid).collection("Friends")
            case .Prayer(let user, _):
                return db.document(user.uid).collection("Prayers")
            }
        }
        
        var documentReference: DocumentReference{
            switch self{
            case .User(let user):
                return db.document(user.uid)
            case .Friend(let user,let friendID):
                if let friendID{ return db.document(user.uid).collection("Friends").document(friendID) }
                else { return db.document(user.uid).collection("Friends").document() }
            case .Prayer(let user, let prayerID):
                if let prayerID{ return db.document(user.uid).collection("Prayers").document(prayerID) }
                else { return db.document(user.uid).collection("Prayers").document() }
            }
        }
    }
 
}

enum FirebaseManagerError: Error{
    case firebaseError(Error)
    case incorrectData
    case noData
        
    var toString: String{
        switch self {
        case .firebaseError(let error):
            return "Error with Firebase: \(error)"
        case .incorrectData:
            return "Incorrect Data"
        case .noData:
            return "No Data"
        }
    }
}
