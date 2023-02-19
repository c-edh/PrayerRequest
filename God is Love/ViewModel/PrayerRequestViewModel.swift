//
//  PrayerRequestViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import UIKit
import NaturalLanguage

enum MachineLearningPredictions: String{
    case depression = "Depression"
    case sucidial = "Suicidal"
}

class PrayerRequestViewModel: ObservableObject{
    @Published var messageIsSuicidal = false{
        didSet{
            if messageIsSuicidal == true{
                messageIsDepression = false
            }
        }
    }
    
    @Published var messageIsDepression = false{
        didSet{
            if messageIsDepression == true{
                messageIsSuicidal = false
            }
        }
    }
    
    private let firebaseManager = FirebaseManager()

    func getUserPrayerRequest(name: String?, prayerRequest: String, prayerImage: UIImage?){
        let date = getTimeStamp()["Date"]
        
        suicidalDepressionDetection(prayerRequest)
        let prayerRequestInfo = [ "Name" : name ?? "Anonymous", "Prayer Request" : prayerRequest, "Date": date ?? "N/A"]
        
        firebaseManager.addPrayerToFireBase(prayerRequestInfo, prayerImage: prayerImage)
    }

    private func suicidalDepressionDetection(_ message: String){
        do{
            let moodDector = try NLModel(mlModel: machineLearningModel().model)
            
            guard let prediction = moodDector.predictedLabel(for: message) else{
                print("couldn't predict")
                return
            }
            
            if prediction == MachineLearningPredictions.sucidial.rawValue{
                messageIsSuicidal = true
                print(MachineLearningPredictions.sucidial)
            }else if prediction == MachineLearningPredictions.depression.rawValue{
                messageIsDepression = true
                print(MachineLearningPredictions.depression)
            }else{
                messageIsSuicidal = false
                messageIsDepression = false
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
