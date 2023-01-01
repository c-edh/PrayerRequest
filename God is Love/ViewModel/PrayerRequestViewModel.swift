//
//  PrayerRequestViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import UIKit
import NaturalLanguage

class PrayerRequestViewModel: ObservableObject{
    
    
    @Published var messageIsSuicidal = false
    @Published var messageIsDepression = false
    
    private let firebaseManager = FirebaseManager()

    func getUserPrayerRequest(name: String?, prayerRequest: String, prayerImage: UIImage?){
        let date = getTimeStamp()["Date"]
        
        suicidalDepressionDetection(prayerRequest)
        firebaseManager.addPrayerToFireBase(name: name, prayerRequest: prayerRequest, date: date, prayerImage: prayerImage)
    }

    
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
