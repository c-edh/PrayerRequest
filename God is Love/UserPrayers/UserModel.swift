//
//  UserModel.swift
//  God is Love
//
//  Created by Corey Edh on 1/19/23.
//

import Foundation
import FirebaseFirestore.FIRDocumentSnapshot


struct UserModel:Identifiable{
    let id = UUID()
    
    let name: String?
    let userID: String?
    let prayerCount: Int?
    var image: UIImage?
    
    init(userDocument: [String:Any]){
        self.name = userDocument["Name"] as? String
        self.prayerCount = userDocument["PrayerCount"] as? Int
        self.image = nil
        self.userID = nil
    }
    
    mutating func addImage(image: UIImage){
        self.image = image
    }
}
