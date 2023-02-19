//
//  UserModel.swift
//  God is Love
//
//  Created by Corey Edh on 1/19/23.
//

import Foundation
import FirebaseFirestore.FIRDocumentSnapshot


struct UserModel:Identifiable{
    var id: UUID
    
    let name: String
    let userID: String
    let prayerCount: Int
    var image: UIImage?
    
//    init(userDocument: DocumentSnapshot){
//
//        
//    }
    
    mutating func addImage(image: UIImage){
        self.image = image
    }



}
