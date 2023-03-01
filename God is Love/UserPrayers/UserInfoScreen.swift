//
//  UserInfoScreen.swift
//  God is Love
//
//  Created by Corey Edh on 8/28/22.
//

import SwiftUI

struct UserInfoScreen: View {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    @StateObject var viewModel = UserInfoScreenViewModel()
    @State var prayerMessagesAreShowing = false
    @State var prayer: PrayerModel?
    
    let user: UserModel? = nil
    
    var body: some View {
        ZStack{
            
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:screenWidth,
                       height:screenHeight)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            VStack{

            HStack(spacing: 50){
                Text("Prayers Requested: \(user?.prayerCount ?? 0)")
                Text("Prayers Prayed for: \(user?.prayerCount ?? 0)")
                
            }.frame(height: 100)
                ListOfUserPrayers(prayers: viewModel.userPrayers, prayer: $prayer, prayerMessagesAreShowing: $prayerMessagesAreShowing)
                
                    .onAppear{
                        Task{
                           await viewModel.getUserPrayerRequest()
                            
                        }
                    }
                
                    .sheet(isPresented: $prayerMessagesAreShowing) {
                        
                        PrayerMessageView(prayerMessages: viewModel.messageForPrayer,
                                          prayer: prayer?.prayer ?? "")
                        
                    }
                
            }.padding([.top])
            
                .navigationTitle("Your Prayers")
            
        }
        
    }
    
}

struct UserInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoScreen()
        PrayerMessageView(prayerMessages: ["Stay Strong", "Keep Fighting","You are loved! Please keep that in mind, Jesus loves you! \n 1 John 4:8"], prayer: "Please pray for me, I dont want to live anymore!")
    }
}


struct ListOfUserPrayers: View {
    
    let prayers: [PrayerModel]

    @Binding var prayer: PrayerModel?
    @Binding var prayerMessagesAreShowing : Bool
        
    var body: some View {
        VStack{
            ScrollView{
                ForEach(prayers){ prayer in
                    VStack{
                        UserPrayers(prayer: prayer)
                            .onTapGesture {

                                self.prayer = prayer
                                prayerMessagesAreShowing = true
                            }
                            .background(.black)
                        
                    }
                }
                
            }.frame(width: UIScreen.main.bounds.width).listRowBackground(Color.clear)

        }.padding([.top])
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
                
            }
            if (prayer.image != nil){
                Image(uiImage:(prayer.image)!)
                    .resizable().aspectRatio(contentMode: .fit).frame(width:100).cornerRadius(100)
                
            }
        }
        .padding().frame(width: UIScreen.main.bounds.width-50)
        
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 4))
    }
}

struct PrayerMessageView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var prayerMessages : [String]
    var prayer: String
    
    var body: some View {
        ZStack{
            
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:screenWidth,
                       height:screenHeight)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            VStack{
                Text(prayer)
                    .font(.system(size:40))
                    .fontWeight(.heavy)
                    .padding()
                
                ScrollView{
                    ForEach(prayerMessages, id:\.self){ message in
                        VStack{
                            Text(message)
                                .font(.system(size: 24))
                                .fontWeight(.heavy).padding()
                            
                            Button(action:{
                                //Report User comments
                            }){
                                Text("Report")
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width-20,alignment: .trailing)
                            }
                            
                        }.background()
                            .frame(width: UIScreen.main.bounds.width-20, alignment: .trailing)
                            .cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 4)).padding(3).shadow(radius: 4)
                    }
                }.frame(width:UIScreen.main.bounds.width)
            }
            
        }
        
    }
}

