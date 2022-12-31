//
//  FirebaseManager.swift
//  God is Love
//
//  Created by Corey Edh on 12/30/22.
//


import Firebase
import FirebaseFirestore


protocol FirebaseManagerProtocol{
    
    func retrievedPrayersRequestFromFirebase()
    
}

enum FirebaseCollection: String{
    
    case PrayersCollection = "Prayers"
    case ReportedCollection = "Reported"
    case UserCollection = "Users"

}



class FirebaseManager{
    
    private let db = Firebase.Firestore.firestore()
    
    //MARK: - User Authentication to Firebase
    
    
    func firebaseCredential(idToken: String?, nonce: String?, loginCompletion: @escaping (Bool)->()){
        
        guard let idToken = idToken else{
            print("Token failed")
            return
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)

        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
                loginCompletion(false)
                return
            }
            loginCompletion(true)
            print("login success")
        }
        
    }
    
    func logOutFromFirebase() -> Bool{
        let firebaseAuth = Auth.auth()
          do{
            try firebaseAuth.signOut()
              return true
          }catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
              return false
          }
    }
    
    
    
    
    
    
    //MARK: - Uploading to Firebase
    
    //Uploads User's Prayer Request To Firebase
    func addPrayerToFireBase(name: String?, prayerRequest: String, date: String?, prayerImage: UIImage?){
        
        var ref: DocumentReference? = nil
        
        
        guard let user = Auth.auth().currentUser else{
            print("No current user Error")
            return
        }
        
        ref = db.collection(FirebaseCollection.PrayersCollection.rawValue).addDocument(data:[
            "Name" : name ?? "Anonymous",
            "UserID": user.uid,
            "Prayer Request" : prayerRequest,
            "Date": date ?? "N/A",
            "Prayer Count": 0,
            "Next Count": 0,
        ]){ err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
        
        
        if let prayerImage = prayerImage, let documentID = ref?.documentID{
            print("Added Image to Document Reference")
            addPrayerRequestImageToFirebase(documentId: documentID, image: prayerImage)
            
        }
        
    }
    

    
    private func addPrayerRequestImageToFirebase(documentId: String, image: UIImage){
        
        let storageRef = Storage.storage().reference().child("Prayers/\(documentId)")
        
        //Image -> Data
        guard let compressedImage = image.jpegData(compressionQuality: 0.75) else{
            print("FAILED TO COMPRESS")
            return
        }
        
        //Type of Data being stored
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //Stores the data (the image) as a image/jpeg in the firebase storage
        storageRef.putData(compressedImage, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil{
                print("Image stored sucessfully")
            }else{
               // print(error?.localizedDescription)
                print("Upload fail")
            }
        }
    
    }
    
    
    func userPrayForPrayer(with id: String, message: String?, date: String, prayerCount: Int){
        
        db.collection(FirebaseCollection.PrayersCollection.rawValue).document(id).updateData(["Prayer Count": prayerCount])

        if let message = message{
            addMessageToPrayerRequest(id: id, message: message, date: date)
        }
    }
    
    
    private func addMessageToPrayerRequest(id: String, message: String, date: String){
        
        let messageData = ["Message": message,
                           "Date": date ]
        
        db.collection(FirebaseCollection.PrayersCollection.rawValue).document(id).updateData(["Messages": FieldValue.arrayUnion([messageData])])
    }
    
    func prayerSkip(count: Int, prayer: PrayerModel){
  
        db.collection(FirebaseCollection.PrayersCollection.rawValue).document(prayer.prayer).updateData(["Next Count": count])
        
        //If Prayer Request was Skipped 10 times, it is reported
        if count <= -10{
            db.collection(FirebaseCollection.ReportedCollection.rawValue).document().setData(["Prayer": prayer.prayer,
                                                          "User ID": prayer.userID])
        }
    }
    
    
    
    
    //MARK: - Retrieving Data from Firebase
    
    
    private func getPrayerImage(id: String, completion: @escaping (UIImage?) -> Void){
        
        let prayerStoredImageRef =  Storage.storage().reference().child("Prayers/\(id)")
        
        prayerStoredImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error{
                print(error.localizedDescription, "Error has occured, default image is displayed")
            }else{
                guard let data = data, let userStoredImage = UIImage(data: data) else{
                    completion(nil)
                    return
                }
                completion(userStoredImage)
            }
        }
        
    }
    
    
    
    func getPrayerRequest(){
        db.collection("Prayers").getDocuments { (data, error) in
            if error == nil{
                print(error?.localizedDescription)
            }
            guard let data = data else{
                return
            }
            for document in data.documents{
                let prayer = document.data()
                
                //Get's every prayer besides the user's
                if prayer["UserID"] as? String != Auth.auth().currentUser?.uid{
                    self.prayers.push(PrayerModel(docID: document.documentID,
                                                  name: (prayer["Name"] as? String) ?? "N/A",
                                                  userID: (prayer["UserID"] as? String) ?? "N/A",
                                                  prayer: (prayer["Prayer Request"] as? String) ?? "N/A",
                                                  date: (prayer["Date"] as? String) ?? "N/A",
                                                  prayerCount: (prayer["Prayer Count"] as? Int) ?? 0,
                                                  nextCount: (prayer["Next Count"] as? Int) ?? 0))
                    
                }
                
                
                self.firebaseManager.getPrayerImage(id: document.documentID) {image in
                    guard let image = image else{
                        return
                    }
                    self.PrayerImage[document.documentID] = image
                    
                }
            }
        }
    }
    
    
    func getPrayerRequestByID(id: String, completion: @escaping ([String:Any]) -> () ){
        self.db.collection("Prayers").document(id).getDocument { (data, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                guard let prayer = data as? [String:Any] else{
                    print("Couldnt get data")
                    return
                }
                completion(prayer)
                //                DispatchQueue.main.async {
                //                    self.userPrayers?.append(PrayerModel(docID: prayerID,
                //                                                         name: (prayer["Name"] as? String) ?? "N/A",
                //                                                         userID: (prayer["UserID"] as? String) ?? "N/A",
                //                                                         prayer: (prayer["Prayer Request"] as? String) ?? "N/A",
                //                                                         date: (prayer["Date"] as? String) ?? "N/A",
                //                                                         prayerCount: (prayer["Prayer Count"] as? Int) ?? 0,
                //                                                         nextCount: (prayer["Next Count"] as? Int) ?? 0))}
                //            }
            }
        }
        
    }
    
    
    






}
