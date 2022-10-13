//
//  PrayersViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/24/22.
//
import Firebase

class PrayersViewModel: ObservableObject{
    
    @Published var prayers = PrayerStack()
    @Published var hasImage = false
    @Published var PrayerImage : [String:UIImage] = [:]
    
    private var db = Firebase.Firestore.firestore()
    
    
    
    func userPray(_ message: String){
        //Pop from Stack
        sendMessageBack(message)
        print("This still did this")
        //Add +1 on prayer in database (Hidden)
        guard let prayer = prayers.peek() else{
            return
        }
        let count = prayer.prayerCount + 1
        self.db.collection("Prayers").document(prayer.docID).updateData(["Prayer Count": count])
        //Inform the Requestor that someone prayed for them
        prayers.pop()
    }
    
    func userSkip(){
        guard let prayer = prayers.peek() else{
            return
        }
        
        let count = prayer.nextCount - 1
        self.db.collection("Prayers").document(prayer.docID).updateData(["Next Count": count])
        
        if prayer.prayerCount + prayer.nextCount == -10{
            tooManySkips(Document: prayer.docID,prayer: prayer.prayer,userID: prayer.userID)
        }
        prayers.pop()
    }
    
    private func tooManySkips(Document:String, prayer:String, userID: String){
        self.db.collection("Reported").document(Document).setData(["Prayer": prayer,
                                                                   "User ID": userID])
    }
    
    //This was change
    func getPrayer() -> PrayerModel?{
        
        guard let prayer = prayers.peek() else{
            return nil
        }
        return prayer
    }
    
    func getPrayersRequest(){
        
        guard let user = Auth.auth().currentUser else{
            print("No current user")
            return
        }
        
        self.db.collection("Prayers").getDocuments { (data, error) in
            if error == nil{
                print(error?.localizedDescription)
            }
            guard let data = data else{
                return
            }
            for document in data.documents{
                let prayer = document.data()
                
                //Get's every prayer besides the user's
                if prayer["UserID"] as? String != user.uid{
                    self.prayers.push(PrayerModel(docID: document.documentID,
                                                  name: (prayer["Name"] as? String) ?? "N/A",
                                                  userID: (prayer["UserID"] as? String) ?? "N/A",
                                                  prayer: (prayer["Prayer Request"] as? String) ?? "N/A",
                                                  date: (prayer["Date"] as? String) ?? "N/A",
                                                  prayerCount: (prayer["Prayer Count"] as? Int) ?? 0,
                                                  nextCount: (prayer["Next Count"] as? Int) ?? 0))
                    
                }
                
                
                self.getPrayerImage(id: document.documentID) { hasImage, image in
                    if hasImage{
                        self.PrayerImage[document.documentID] = image
                    }
                }
            }
        }
    }
    

private func getPrayerImage(id: String, completion: @escaping (Bool, UIImage?) -> Void){
    
    let prayerStoredImageRef =  Storage.storage().reference().child("Prayers/\(id)")
    
    prayerStoredImageRef.getData(maxSize: 1*1024*1024) { data, error in
        if let error = error{
            print(error.localizedDescription, "Error has occured, default image is displayed")
        }else{
            guard let data = data, let userStoredImage = UIImage(data: data) else{
                completion(false,nil)
                return
            }
            completion(true,userStoredImage)
        }
    }
    
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

private func sendMessageBack(_ message: String){
    
    if message == ""{
        print("Empty message")
        return
    }
    
    guard let prayer = prayers.peek() else{
        return
    }
    
    guard let date = getTimeStamp()["Date"] else{
        return
    }
    
    let messageData = ["Message": message,
                       "Date": date ]
    
    self.db.collection("Prayers").document(prayer.docID).updateData(["Messages": FieldValue.arrayUnion([messageData])])
    
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
