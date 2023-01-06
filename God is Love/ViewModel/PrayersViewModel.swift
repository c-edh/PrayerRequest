//
//  PrayersViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/24/22.
//

import Foundation

class PrayersViewModel: ObservableObject{
    
    @Published var prayers = PrayerStack()
    @Published var hasImage = false
   // @Published var PrayerImage : [String:UIImage] = [:]
        
    let firebaseManager = FirebaseManager()
    
    
    //This was change
    func getPrayer() -> PrayerModel?{
        
        guard let prayer = prayers.peek() else{
            return nil
        }
        return prayer
    }
    
    func getPrayersRequest(){
        
        firebaseManager.getPrayerRequest { prayer in
            self.prayers.push(prayer)
        }
        
        
    }
    
    
    func userPray(_ message: String){
        guard let id = prayers.peek()?.docID, let prayerCount = prayers.peek()?.prayerCount, let date = getTimeStamp()["Date"] else{
            return
        }
        let count = prayerCount + 1
        
        firebaseManager.userPrayForPrayer(with: id, message: message, date: date, prayerCount: count)
        
        prayers.pop()
    }
    
    
    func userSkip(){
        guard let prayer = prayers.peek() else{
            return
        }
        
        let count = prayer.nextCount - 1
        
        firebaseManager.prayerSkip(count: count, prayer: prayer)
        
        prayers.pop()
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




struct PrayerStack{
    
    var items: [PrayerModel] = []
    
    func peek() -> PrayerModel? {
        guard let topElement = items.first else {
            return nil
        }
        
        return topElement
    }
    
    mutating func pop() {
        items.removeFirst()
    }
    
    mutating func push(_ element: PrayerModel) {
        items.insert(element, at: 0)
    }
    
    
}
