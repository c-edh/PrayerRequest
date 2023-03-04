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

    @Published var user: UserModel? = nil
    @Published var userPrayers : [PrayerModel] = []
    @Published var messageForPrayer: [String] = []

    private let firebaseManager = FirebaseManager()
    
    func getUserData(){
        guard let user = Auth.auth().currentUser else{ return }
                
        let reference = Collection.UserCollection(.User(user)).documentReference
        
        firebaseManager.getFirebaseDocumentData(for: reference) { userData in
            switch userData {
            case .success(let userInfo):
                self.user = UserModel(userDocument: userInfo)
                print(userInfo)
            
            case .failure(let failure):
                print(failure)
            }
        }
    }
 
    func getUserPrayerRequest() async{
        guard let user = Auth.auth().currentUser else{ return }
        
        let reference = Collection.UserDocument.Prayer(user, documentID: nil).userCollectionReference
        
        firebaseManager.getFirebaseDataInCollection(for: reference,allowUserData: true){ result in
            switch result {
            case .success(let prayers):
                var prayerArray: [PrayerModel] = []
                for prayer in prayers{
                    print(prayer)
                    prayerArray.append(.init(prayer: prayer))
                }
                print(prayerArray)
                self.userPrayers = prayerArray
            
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
      //  firebaseManager.addFriends(friendsID: "afdakflTestklfakalf")
    }
    
}

