//
//  FirebaseManager.swift
//  God is Love
//
//  Created by Corey Edh on 12/30/22.
//


import Firebase
import FirebaseFirestore


protocol FirebaseManagerProtocol: LoginProtocol, UserProtocol, PrayerProtocol{
    static var shared: FirebaseManager { get }
}

protocol LoginProtocol{
    func firebaseCredential(idToken: String, nonce: String, loginCompletion: @escaping (Result<Bool,Error>)->())
    func setUpUser(userInfo: [String: Any])
    func logOutFromFirebase() -> Bool
}

extension LoginProtocol{
    func firebaseCredential(idToken: String, nonce: String, loginCompletion: @escaping (Result<Bool,Error>)->()){
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
                loginCompletion(.failure(error))
                return
            }
            loginCompletion(.success(true))
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
}

protocol UserProtocol{
    func getUserPrayerRequestMessages(for prayerID: String, completion: @escaping (Result<[String], FirebaseManagerError>) -> Void )
    func addFriends(friendsID: String)

}
protocol PrayerProtocol{
    func addPrayerToFireBase(_ prayerRequest: [String: Any], prayerImage: UIImage?)
  //  func addFriendPrayerToFireBase(name: String?, prayerRequest: String, date: String?, prayerImage: UIImage?, friendsID: String?)
    func userPrayForPrayer(with id: String, message: String?, date: String, prayerCount: Int)
    func getPrayerRequest(completion: @escaping (Result<PrayerModel, FirebaseManagerError>) -> ())
    func getPrayerRequestByID(id: String, completion: @escaping (Result<PrayerModel, FirebaseManagerError>) -> ())
}


enum FirebaseManagerError: Error{
    case firebaseError(Error)
    case incorrectData //Failed to convert, or is nil
    case noData
    
    
    var toString: String{
        switch self {
        case .firebaseError(let error):
            return "Error with Firebase: \(error)"
        case .incorrectData:
            return "Incorrect Data"
        case .noData:
            return "No Data"
        }
    }
}

class FirebaseManager: FirebaseManagerProtocol{

    private let db = Firebase.Firestore.firestore()
    static let shared = FirebaseManager()
    
    //MARK: - User Authentication to Firebase
    func setUpUser(userInfo: [String:Any]){
        guard let user = Auth.auth().currentUser else{
            print("Didnt get user id")
            return
        }
        
        Collection.UserCollection(.User(user)).reference.setData(userInfo)
    }

    func addFriends(friendsID: String){
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        Collection.UserCollection(.User(user)).reference.getDocument{ document, error in
            guard let friendCount = document?.get("FriendsCount") as? Int else{
                return
            }

            Collection.UserCollection(.Friend(user, friendsID)).reference.setData(["Exist": true])
            Collection.UserCollection(.User(user)).reference.updateData(["FriendsCount": friendCount+1])

        }
    }
    
    //MARK: - Uploading to Firebase
    
    func addPrayerToFireBase(_ prayerRequest: [String: Any], prayerImage: UIImage?) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var prayerRequestInfo = prayerRequest
        prayerRequestInfo = ["UserID": user.uid, "Prayer Count": 0, "Next Count": 0]
        
        let reference = Collection.PrayerCollection().reference
        reference.setData(prayerRequestInfo){ err in
            
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(String(describing: reference.documentID))")
            }
        }
        
        Collection.UserCollection(.Prayer(user, reference.documentID)).reference.setData(prayerRequestInfo)
        
        if let prayerImage = prayerImage{
            print("Added Image to Document Reference")
            addPrayerRequestImageToFirebase(documentId: reference.documentID, image: prayerImage)
        }
        
    }
    
    
    private func addPrayerRequestImageToFirebase(documentId: String, image: UIImage){
        
        let storageRef = Storage.storage().reference().child("Prayers/\(documentId)")

        guard let compressedImage = image.jpegData(compressionQuality: 0.75) else{
            print("FAILED TO COMPRESS")
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(compressedImage, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil{
                print("Image stored sucessfully")
            }else{
                print("Upload fail")
            }
        }
        
    }
    
    func userPrayForPrayer(with id: String, message: String?, date: String, prayerCount: Int){
        Collection.PrayerCollection(id).reference.updateData(["Prayer Count": prayerCount])
        if let message = message{
            addMessageToPrayerRequest(id: id, message: message, date: date)
        }
    }
    
    private func addMessageToPrayerRequest(id: String, message: String, date: String){
        let messageData = ["Message": message, "Date": date]
        Collection.PrayerCollection(id).reference.updateData(["Messages": FieldValue.arrayUnion([messageData])])
    }
    
    //MARK: - Retrieving Data from Firebase
   
    
    func getPrayerRequest(completion: @escaping (Result<PrayerModel, FirebaseManagerError>) -> ()){
//        guard let user = Auth.auth().currentUser else{
//            return
//        }
//        db.collection("Prayers").limit(to: 10).whereField("UserID", isNotEqualTo: user.uid).getDocuments { (data, error) in
//            if error != nil{
//                print(error?.localizedDescription ?? "Error")
//            }
//
//            guard let data = data else{
//                completion(.failure(.incorrectData))
//                return
//            }
//
//            for document in data.documents{
//
//                self.getPrayerImage(id: document.documentID) { result in
//                    var prayer = PrayerModel(prayerDocument: document)
//
//                    switch result {
//                    case .success(let image):
//                        prayer.addImage(image: image)
//                        completion(.success(prayer))
//
//                    case .failure(let noImageError):
//                        completion(.success(prayer))
//
//                        ////Most likely user has no Image for Prayer
//                        print(noImageError.localizedDescription)
//                    }
//
//                }
//            }
//        }
    }
    
    
    func getPrayerRequests(_ lastPrayer: DocumentSnapshot? =  nil, completion: @escaping (Result<[PrayerModel], FirebaseManagerError>)->Void){
        guard let user = Auth.auth().currentUser else{
            return
        }
        if let lastPrayer = lastPrayer{
            Collection.PrayerCollection().collectionReference.start(afterDocument: lastPrayer).limit(to: 10).whereField("UserID", isNotEqualTo: user.uid).getDocuments { data, error in
                
                if error != nil {
                  //  completion(.failure(.firebaseError()))
                    return
                }
                
                guard let data = data else{
                    completion(.failure(.noData))
                    return
                }
                
                var prayerArray: [PrayerModel] = []
                for document in data.documents{
                    prayerArray.append(PrayerModel(prayerDocument: document))
                }
                completion(.success(prayerArray))
            }
            
        }else{
            Collection.PrayerCollection().collectionReference.limit(to: 10).whereField("UserID", isNotEqualTo: user.uid).getDocuments { data, error in
                
                if error != nil {
                  //  completion(.failure(.firebaseError()))
                    return
                }
                
                guard let data = data else{
                    completion(.failure(.noData))
                    return
                }
                
                var prayerArray: [PrayerModel] = []
                for document in data.documents{
                    prayerArray.append(PrayerModel(prayerDocument: document))
                }
                completion(.success(prayerArray))
            }
            
        }
        
        
    }
    
    
    func getPrayerRequestByID(id: String, completion: @escaping (Result<PrayerModel, FirebaseManagerError>) -> ()){
        
        Collection.PrayerCollection(id).reference.getDocument { (data, error) in
            if let error = error{
                completion(.failure(.firebaseError(error)))
                print(error.localizedDescription)
            }else{
                guard let data = data else{
                    completion(.failure(.incorrectData))
                    return
                }
                
                //Gets Prayer images if the prayer request has an image
                self.getPrayerImage(id: id) { result in
                    var prayer = PrayerModel(prayerDocument: data)
                    
                    switch result {
                    case .success(let image):
                        prayer.addImage(image: image)
                        completion(.success(prayer))
                    
                    case .failure(let noImageError):
                        completion(.success(prayer))
                        
                        ////Most likely user has no Image for Prayer
                        print(noImageError.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func getPrayerImage(id: String, completion: @escaping (Result<UIImage, FirebaseManagerError>) -> Void){
        let prayerStoredImageRef =  Storage.storage().reference().child("Prayers/\(id)")
        
        prayerStoredImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error{
                print(error.localizedDescription, "Error has occured, default image is displayed")
                completion(.failure(.firebaseError(error)))
            }else{
                guard let data = data, let userStoredImage = UIImage(data: data) else{
                    completion(.failure(.incorrectData))
                    return
                }
                completion(.success(userStoredImage))
            }
        }
        
    }

    //MARK: - User Prayers
    //Retrieves the user's prayer request, getting id from userprayers in their profile and retrieveing it from prayer collection
    func getUserPrayerRequest(completion: @escaping (Result<PrayerModel, Error>) -> Void){
        guard let user = Auth.auth().currentUser else{
            return
        }
        
        //Gets user's prayer request reference ID
        Collection.UserCollection(.User(user)).reference.collection("Prayers").getDocuments { [weak self] (data, error) in
            if let data = data{
                for document in data.documents{
                    let id = document.documentID
                    
                    //Gets prayers from prayer collection using ID
                    self?.getPrayerRequestByID(id: id) { result in
                        switch result {
                        case .success(let prayer):
                            completion(.success(prayer))
                        case .failure(let error):
                            completion(.failure(error))
                            
                        }
                    }
                }
            }
        }
    }
    
    func getUserPrayerRequestMessages(for prayerID: String, completion: @escaping (Result<[String], FirebaseManagerError>) -> Void ){
        
        db.collection("Prayers").document(prayerID).getDocument { (data, error) in
            if let error = error{
                completion(.failure(.firebaseError(error)))
            }
            guard let data = data, let messages = data["Messages"] as? [[String:String]]  else{
                completion(.failure(.incorrectData))
                return
            }
            
            var messageArray :[String] = []
            
            for message in messages {
                messageArray.append(message["Message"] ?? "Message Error")
            }
            
            completion(.success(messageArray))
        }
    }
    
}
