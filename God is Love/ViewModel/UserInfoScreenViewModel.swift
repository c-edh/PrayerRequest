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
    @Published var messageForPrayer: [String] = []

    let firebaseManager = FirebaseManager()

 
    func getUserPrayerRequest(){
        firebaseManager.delegate = self
        print("this ran")
        firebaseManager.getUserPrayerRequest()
    
    }
    
    func getPrayerMessages(with prayerID:String){
        firebaseManager.getUserPrayerRequestMessages(for: prayerID)
    }
    
}

extension UserInfoScreenViewModel: FirebaseManagerProtocol{
    
    func retrievedPrayersRequest(prayerRequest: PrayerModel) {
        DispatchQueue.main.async {
            self.userPrayers.append(prayerRequest)
        }
    }
    
    func retrievedPrayerMessagee(message: [String]) {
        DispatchQueue.main.async{
            self.messageForPrayer = message
        }
    }
    
}
