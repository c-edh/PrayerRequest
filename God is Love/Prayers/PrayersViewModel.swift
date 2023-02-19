//
//  PrayersViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/24/22.
//

import Foundation
import Firebase

class PrayersViewModel: ObservableObject{
    
    
    let firebaseManager = FirebaseManager.shared
    @Published var prayer: PrayerModel? = nil
    private var prayers : [PrayerModel] = []
    private var prayerIndex =  0
    
    func getPrayer(){
        if !prayers.isEmpty{
            prayerIndex += 1
            let prayer = prayers[prayerIndex]
            self.prayer = prayer
        } else if prayerIndex == prayers.count{
            let prayer = prayers[prayerIndex]
            self.prayer = prayer
            getPrayersRequest(prayers.last?.snapShot)
            self.prayers = Array(prayers[11...prayers.count])
        }
    }
    
    func getPrayersRequest(_ lastPrayer: DocumentSnapshot? = nil){
        print("this ran")
        firebaseManager.getPrayerRequests(lastPrayer) { result in
            switch result{
            case .success(let prayers):
                self.prayers = prayers
                DispatchQueue.main.async {
                    self.getPrayer()
                }
            case .failure(let error):
                print(error.toString)
            }
        }
    }
    
    
    func userPray(_ message: String? = nil){
        let prayer = prayers[prayerIndex]
        guard let date = getTimeStamp()["Date"] else{
            return
        }
        let count = prayer.prayerCount + 1
        firebaseManager.userPrayForPrayer(with: prayer.docID, message: message, date: date, prayerCount: count)
    }

    private func getTimeStamp() -> [String:String]{
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let tripDate = dateFormat.string(from: date)
        dateFormat.dateFormat = "HH:mm:ss"
        let timeString = dateFormat.string(from: date)
        
        return ["Date": tripDate, "Time": timeString]
        
    }
    
}
