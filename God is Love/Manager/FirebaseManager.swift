//
//  FirebaseManager.swift
//  God is Love
//
//  Created by Corey Edh on 12/30/22.
//


import Firebase

class FirebaseManager: FirebaseManagerProtocol{
    
    private let db = Firebase.Firestore.firestore()
    static let shared = FirebaseManager()
    
    //MARK: - User Authentication to Firebase
    func setUpUser(userInfo: [String:Any]){
        guard let user = Auth.auth().currentUser else{ return }
        Collection.UserCollection(.User(user)).documentReference.setData(userInfo)
    }
    
    //MARK: - Uploading to Firebase
    
    func addToFirebase(with reference: Collection, data: [String: Any], completion: @escaping (_ documentReference: String) -> Void){
        guard let user = Auth.auth().currentUser else{ return }
        
        var fireBaseData = data
        fireBaseData["UserID"] = user.uid
        
        reference.documentReference.setData(fireBaseData){ err in
            if let err = err { print("Error adding document: \(err)") }
            else { completion(reference.documentReference.documentID) }
        }
    }
    
    func addImageToFireBase(documentId: String, image: UIImage){
        let storageRef = Storage.storage().reference().child("Prayers/\(documentId)")
        guard let compressedImage = image.jpegData(compressionQuality: 0.75) else{ return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(compressedImage, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil{ print("Image stored sucessfully") }
            else{ print("Upload fail") }
        }
    }
    
    func updateDataInFirebase(at reference: DocumentReference, data: [String:Any]){
        reference.updateData(data)
    }
    
    //MARK: - Retrieving Data from Firebase
    
    func getFirebaseDataInCollection(for reference: CollectionReference, allowUserData: Bool = false, limitAmount: Int = 10, completion: @escaping (Result<[[String:Any]], FirebaseManagerError>) -> Void){
        guard let user = Auth.auth().currentUser else{ return }
        
        var query = reference.limit(to: limitAmount)
        
        if !allowUserData{ query = reference.limit(to: limitAmount).whereField("UserID", isNotEqualTo: user.uid ) }
        
        query.getDocuments { (collectionData, error) in
            if let error { completion(.failure(.firebaseError(error))) }
            
            guard let collection = collectionData else{
                completion(.failure(.noData))
                return
            }
            var documentDataArray: [[String:Any]] = []
            for document in collection.documents{
                documentDataArray.append(document.data())
            }
            completion(.success(documentDataArray))
        }
    }
    
    func getFirebaseDocumentData(for reference: DocumentReference, completion: @escaping (Result<[String:Any], FirebaseManagerError>) -> Void){
        reference.getDocument { (document, error) in
            if let error = error{ completion(.failure(.firebaseError(error))) }
            else{
                guard let document = document, let data = document.data() else{
                    completion(.failure(.incorrectData))
                    return
                }
                completion(.success(data))
            }
        }
    }
    
    func getFirebaseImage(id: String, completion: @escaping (Result<UIImage, FirebaseManagerError>) -> Void){
        let prayerStoredImageRef =  Storage.storage().reference().child("Prayers/\(id)")
        
        prayerStoredImageRef.getData(maxSize: 1*1024*1024) { data, error in
            if let error = error{ completion(.failure(.firebaseError(error))) }
            else{
                guard let data = data, let userStoredImage = UIImage(data: data) else{
                    completion(.failure(.incorrectData))
                    return
                }
                completion(.success(userStoredImage))
            }
        }
    }
    
    func getUserPrayerRequestMessages(for prayerID: String, completion: @escaping (Result<[String], FirebaseManagerError>) -> Void ){
        db.collection("Prayers").document(prayerID).getDocument { (data, error) in
            if let error = error{ completion(.failure(.firebaseError(error))) }
            
            guard let data = data, let messages = data["Messages"] as? [[String:String]]  else{
                completion(.failure(.incorrectData))
                return
            }
            
            var messageArray : [String] = []
            
            for message in messages {
                messageArray.append(message["Message"] ?? "Message Error")
            }
            completion(.success(messageArray))
        }
    }
}
