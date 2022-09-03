//
//  UserInfoScreen.swift
//  God is Love
//
//  Created by Corey Edh on 8/28/22.
//

import SwiftUI

struct UserInfoScreen: View {
    @StateObject var viewModel = UserInfoScreenViewModel()
    
    
    var body: some View {
        VStack{
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100).foregroundColor(.blue)
            
            Text("Your Prayers").foregroundColor(.blue)
                .onAppear{
                viewModel.getUserPrayersID()
            }
            
            List{
                ForEach(viewModel.userPrayers){ prayer in
                    VStack{
                        UserPrayers(prayer: prayer)                        
                    }

                }
                VStack{
                    HStack{
                        UserPrayers(prayer: PrayerModel(docID: "NA", name: "Corey", userID: "fdafa", prayer: "Please Pray for me", date: "Jan 18, 2022", prayerCount: 0, nextCount: 0, hasImage: false))
                   
                    }
                    //.frame(alignment: .center)

                    Divider()}
                
                
            }.overlay(Divider().background(.blue), alignment: .top)
        
    }
    }
}

struct UserInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoScreen()
    }
}

struct UserPrayers: View {
    @State var prayer: PrayerModel
    
    var body: some View {
        HStack{
        VStack{
            HStack{
                Text("Prayer")
                Text(prayer.date) //prayer.date
                
            }
            
            Text(prayer.prayer) //prayer.prayer
            HStack{
                Text("Amount of Prayers")
                Text(String(prayer.prayerCount)).fontWeight(.bold) //prayer.count
            }.padding()
            
        }.foregroundColor(.blue)
            if prayer.hasImage{
                Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit).frame(width:100).cornerRadius(100)
                
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 4))
    }
}
