//
//  PrayerModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import UIKit.UIImage

struct PrayerModel:Identifiable{
    let id = UUID()
    let docID: String
    let name: String
    let userID: String
    let prayer: String
    let date: String
    let prayerCount: Int
    let nextCount: Int
    var image: UIImage?
//    var snapShot: DocumentSnapshot
    
    init(prayer:[String: Any]){
//        self.snapShot = prayerDocument
        self.docID = "DocumentID" //DocumentID Place holder
        self.name = prayer["Name"] as? String ?? "No Name"
        self.userID = prayer["UserID"] as? String ?? "N/A"
        self.prayer = prayer["Prayer Request"] as? String ?? "No Prayer"
        self.date = prayer["Date"] as? String ?? "N/A"
        self.prayerCount = prayer["Prayer Count"] as? Int ?? 0
        self.nextCount = prayer["Next Count"] as? Int ?? 0
        self.image = nil
    }
    
    mutating func addImage(image: UIImage){
        self.image = image
    }
}
