//
//  PrayerModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/29/22.
//

import Foundation

public struct PrayerModel: Identifiable, Codable{
    public var id = UUID()

    let docID: String
    let name: String
    let userID: String
    let prayer: String
    let date: String
    let prayerCount: Int
    let nextCount: Int
        
    enum CodingKeys: String,  CodingKey{
        
        case docID
        case name
        case userID
        case prayer
        case date
        case prayerCount
        case nextCount 
        
    }



}
