//
//  PrayerRequestViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import Firebase
import FirebaseFirestore
import NaturalLanguage

class PrayerRequestViewModel: ObservableObject{
    
    private var db = Firebase.Firestore.firestore()
    
    @Published var messageIsSuicidal = false
    @Published var messageIsDepression = false
    
    private func suicidalDepressionDetection(_ message: String){
        do{
            let moodDector = try NLModel(mlModel: machineLearningModel().model)
            guard let prediction = moodDector.predictedLabel(for: message) else{
                print("couldn't predict")
                return
            }
            
            //
            if prediction == "Suicidal"{
                messageIsSuicidal = true
                messageIsDepression = false
                print("Suicide detected")
            }else if prediction == "Depression"{
                messageIsDepression = true
                messageIsSuicidal = false
                print("depression detected")
            }else{
                print("Normal Message, no suicidal or depression detected")
            }
            
            
        } catch{
            fatalError("No to load a part in NL model")
        }
        
        
        
    }
    
    
    func uploadPrayerRequest(name:String?, prayerRequest:String, prayerImage:UIImage?){
        var ref: DocumentReference? = nil
        
        guard let date = getTimeStamp()["Date"] else{
            print("No date Error")
            return
        }
        
        guard let user = Auth.auth().currentUser else{
            print("No current user Error")
            return
        }
        
        suicidalDepressionDetection(prayerRequest)
        
        
        if let name = name{
            
            ref = db.collection("Prayers").addDocument(data:[
                "Name" : name,
                "UserID": user.uid,
                "Prayer Request" : prayerRequest,
                "Date": date,
                "Prayer Count": 0,
                "Next Count": 0,
            ]){ err in
                
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
                
            }
        }else{
            ref = db.collection("Prayers").addDocument(data:[
                "Name" : "Anonymous",
                "UserID": user.uid,
                "Prayer Request" : prayerRequest,
                "Date": date,
                "Prayer Count": 0,
                "Next Count": 0,
            ]){ err in
                
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
                
            }
            
        }
        
        db.collection("Users").document(user.uid).collection("Prayers").document(ref!.documentID).setData(["Prayer Request": prayerRequest])
        
        guard let ref = ref, let prayerImage = prayerImage else {
            print("no ref or image")
            return
        }
        
        uploadUserPrayerPicture(with: prayerImage, id: ref.documentID)
    }
    
    private func uploadUserPrayerPicture(with image: UIImage, id: String){
        print("UPLOAD USER Prayer PICTURE HAS STARTED")
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            // ...
            
            
            //Where in firebase it will be stored
            let storageRef = Storage.storage().reference().child("Prayers/\(id)")
            
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
                    print(error?.localizedDescription)
                    print("Upload fail")
                }
            }}
        
        
        
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
