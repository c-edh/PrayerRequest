//
//  UserInfoScreenViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import Foundation
import Firebase

class UserInfoScreenViewModel: ObservableObject{
    @Published var userPrayers : [PrayerModel] = []
    @Published var prayerImages: [String:UIImage] = [:]
    private var db = Firestore.firestore()

 
    func getUserPrayersID(){
        
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        self.db.collection("Users").document(user.uid).collection("Prayers").getDocuments { (data, error) in
            if let data = data{
                for document in data.documents{
                    self.getPrayersInfo(prayerID: document.documentID)
                    print(document)
                    
                }
            }
        }
    }
    
    private func getPrayersInfo(prayerID : String){
        
        self.db.collection("Prayers").document(prayerID).getDocument { (data, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                guard let data = data else{
                    print("Couldnt get data")
                    return
                }
                let prayer = data
                
                    self.userPrayers.append(PrayerModel(docID: prayerID,
                                             name: (prayer["Name"] as? String) ?? "N/A",
                                             userID: (prayer["UserID"] as? String) ?? "N/A",
                                             prayer: (prayer["Prayer Request"] as? String) ?? "N/A",
                                             date: (prayer["Date"] as? String) ?? "N/A",
                                             prayerCount: (prayer["Prayer Count"] as? Int) ?? 0,
                                             nextCount: (prayer["Next Count"] as? Int) ?? 0,
                                             hasImage:(prayer["hasImage"] as? Bool ?? false)))
            
            
            //PrayerID -> PrayerImage
                if prayer["hasImage"] as? Bool ?? false{
                    self.prayerImages[prayerID] = self.getPrayerImage(with:prayerID)
                }
                
            }
        }
    }
    
    private func getPrayerImage(with prayerID: String) -> UIImage{
        //TODO add Prayer Images
        return UIImage(systemName: "photo")!
    }
    
}
