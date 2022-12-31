//
//  UserInfoScreenViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import Foundation
import Firebase

class UserInfoScreenViewModel: ObservableObject{
    
    @Published var userPrayers : [PrayerModel]?
    @Published var prayerImages: [String:UIImage] = [:]

    private var db = Firestore.firestore()
    let firebaseManager = FirebaseManager()

 
    func getUserPrayersID(){
        
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        self.db.collection("Users").document(user.uid).collection("Prayers").getDocuments { (data, error) in
            if let data = data{
                
                for document in data.documents{
                    
                    let id = document.documentID
                    
                    self.firebaseManager.getPrayerRequestByID(id: id, completion: <#T##([String : Any]) -> ()#>)
                    self.getPrayersInfo(prayerID: document.documentID)
                    print(document)
                    
                }
            }
        }
        
    }
    

    
    private func getPrayersInfo(prayerID : String){
        
//        self.db.collection("Prayers").document(prayerID).getDocument { (data, error) in
//            if let error = error{
//                print(error.localizedDescription)
//            }else{
//                guard let prayer = data else{
//                    print("Couldnt get data")
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.userPrayers?.append(PrayerModel(docID: prayerID,
//                                                         name: (prayer["Name"] as? String) ?? "N/A",
//                                                         userID: (prayer["UserID"] as? String) ?? "N/A",
//                                                         prayer: (prayer["Prayer Request"] as? String) ?? "N/A",
//                                                         date: (prayer["Date"] as? String) ?? "N/A",
//                                                         prayerCount: (prayer["Prayer Count"] as? Int) ?? 0,
//                                                         nextCount: (prayer["Next Count"] as? Int) ?? 0))}
//            }
//        }
    }

    
    
    private func getPrayerImage(with prayerID: String, completion: @escaping (UIImage) -> Void){

        let userStoredImageRef =  Storage.storage().reference().child("Prayers/\(prayerID)")
        
        userStoredImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error{
                print(error.localizedDescription, "Error has occured, default image is displayed")
            }else{
                let userStoredImage = UIImage(data: data!)
                completion(userStoredImage!)

            }
        }
    }
    
    func getPrayerMessages(with prayerID:String, onCompletion: @escaping ([String]) -> Void){
        
        db.collection("Prayers").document(prayerID).getDocument { (data, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            guard let data = data else{
                print("Couldn't retrieve data from firebase")
                return
            }
            print(data["Messages"])
            
            guard let messages = data["Messages"] as? [[String:String]] else{
                print("messages error")
                return
            }
            
            var messageArray :[String] = []
            
            for message in messages {
                messageArray.append(message["Message"] ?? "Message Error")
            }
            
            onCompletion(messageArray)
            
        }
        
    }
    
}
