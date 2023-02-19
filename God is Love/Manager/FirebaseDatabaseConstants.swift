//
//  K.swift
//  God is Love
//
//  Created by Corey Edh on 12/31/22.
//

import Foundation
import Firebase


enum Collection{
   
   case PrayerCollection(String? = nil)
   case UserCollection(UserDocument)
   
   var reference: DocumentReference{
       let db = Firebase.Firestore.firestore()
       switch self {
       case .PrayerCollection(let documentID):
           if let documentID = documentID{
               return db.collection("Prayers").document(documentID)
           }else{
               return db.collection("Prayers").document()
           }
       case .UserCollection(let UserDocument):
           return UserDocument.reference
       }
   }
    
    enum UserDocument{
        private var db : CollectionReference{ return Firebase.Firestore.firestore().collection("Users") }

        case User(User)
        case Friend(User,String)
        case Prayer(User,String)
        
        var reference: DocumentReference{
            switch self{
            case .User(let user):
                return db.document(user.uid)
            case .Friend(let user,let friendID):
                return db.document(user.uid).collection("Friends").document(friendID)
            case .Prayer(let user, let prayerID):
                return db.document(user.uid).collection("Prayers").document(prayerID)
            }
        }
    }
    
    
    
}
