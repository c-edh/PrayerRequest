//
//  PrayerModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import FirebaseFirestore
import UIKit.UIImage

struct PrayerModel:Identifiable{
    var id: UUID
    
   
    let docID: String
    let name: String
    let userID: String
    let prayer: String
    let date: String
    let prayerCount: Int
    let nextCount: Int
    var image: UIImage?
    
    init(prayerDocument: DocumentSnapshot){
        
        self.id = UUID()
        self.docID = prayerDocument.documentID
        self.name = prayerDocument.get("Name") as? String ?? "No name"
        self.userID = prayerDocument.get("UserID") as? String ?? "N/A"
        self.prayer = prayerDocument.get("Prayer Request") as? String ?? "No Prayer"
        self.date = prayerDocument.get("Date") as? String ?? "N/A"
        self.prayerCount = prayerDocument.get("Prayer Count") as? Int ?? 0
        self.nextCount = prayerDocument.get("Next Count") as? Int ?? 0
        self.image = nil
        
        
    }
    
    mutating func addImage(image: UIImage){
        self.image = image
    }



}
