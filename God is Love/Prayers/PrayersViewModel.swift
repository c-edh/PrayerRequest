//
//  PrayersViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/24/22.
//

import Foundation
import Firebase

class PrayersViewModel: ObservableObject{
    
    @Published var prayer: PrayerModel? {
        didSet{
            firebaseManager.getFirebaseImage(id: prayer!.docID) {[weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.prayer!.addImage(image: image)
                    }
                case .failure(_):
                    print("no image")
                }
            }
        }
    }
    private var prayers : [PrayerModel] = []
    private var prayerIndex =  0
    
    private let firebaseManager = FirebaseManager.shared
   
    func getPrayer(){
        if prayerIndex < prayers.count{
            prayerIndex += 1
            let prayer = prayers[prayerIndex]
            self.prayer = prayer
        } else{
            let prayer = prayers[prayerIndex]
            self.prayer = prayer
          //  getPrayersRequest(prayers.last?.snapShot)
            self.prayers = Array(prayers[11...prayers.count])
        }
        print(prayerIndex)
        print(prayers.count)
    }
    
    func getPrayersRequest(){
        let reference = Collection.PrayerCollection().collectionReference
        firebaseManager.getFirebaseDataInCollection(for: reference) { result in
            switch result {
            case .success(let prayers):
                var prayersArray: [PrayerModel] = []
                for prayer in prayers{
                    prayersArray.append(.init(prayer: prayer))
                }
                
                self.prayers = prayersArray
                DispatchQueue.main.async {
                    self.getPrayer()
                }
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
    func userPray(_ message: String? = nil){
        let prayer = prayers[prayerIndex]
        var data = ["Prayer Count": prayer.prayerCount + 1] as [String: Any]
        
        let location: Collection = .PrayerCollection(documentID: prayer.docID)

        if let message, let date = getTimeStamp()["Date"]{
            data["Message"] = message
            data["Date"] = date
            firebaseManager.updateDataInFirebase(at: location, data: data)

        }else{
            firebaseManager.updateDataInFirebase(at: location, data: data)
        }
        getPrayer()
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
