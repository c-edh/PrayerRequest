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
    let firebaseManager = FirebaseManager()

 
    func getUserPrayerRequest(){
        print("this ran")
        firebaseManager.getUserPrayerRequest { listOfUserPrayers in
            
            guard let listOfUserPrayers = listOfUserPrayers else{
                return
            }
            
            print(listOfUserPrayers)
            
            DispatchQueue.main.async {
                self.userPrayers = listOfUserPrayers
            }
        }
    
    }
    
    func getPrayerMessages(with prayerID:String, onCompletion: @escaping ([String]) -> Void){
        firebaseManager.getUserPrayerRequestMessages(for: prayerID) { messages in
            onCompletion(messages)
        }
    }
    
}
