//
//  UserInfoScreenViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import Foundation
import Firebase

@MainActor
class UserInfoScreenViewModel: ObservableObject{

    
  //  @Published var user: UserModel
    @Published var userPrayers : [PrayerModel] = []
    @Published var messageForPrayer: [String] = []

    private let firebaseManager = FirebaseManager()
    
    func getUserData(){
//        firebase.getUserData(){ user in
//            self.user = user
//        }
    }
 
    func getUserPrayerRequest() async{
        
        firebaseManager.getUserPrayerRequest { result in
            switch result {
            
            case .success(let prayer):
                self.userPrayers.append(prayer)
            
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getPrayerMessages(with prayerID:String?) async{
        guard let prayerID else{
            print("no prayerId")
            return
        }
        firebaseManager.getUserPrayerRequestMessages(for: prayerID) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messageForPrayer = messages
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func addFriend(){
        firebaseManager.addFriends(friendsID: "afdakflTestklfakalf")
    }
    
}

