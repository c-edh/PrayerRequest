//
//  UserInfoScreen.swift
//  God is Love
//
//  Created by Corey Edh on 8/28/22.
//

import SwiftUI

struct UserInfoScreen: View {
    @StateObject var viewModel = UserInfoScreenViewModel()
    @State private var prayerMessageIsShowing = false
    @State var prayerMessage : [String] = []
    @State var prayer = ""
    
    
    var body: some View {
        ZStack{
            
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.height,
                       height:UIScreen.main.bounds.height)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            
            VStack{
       
                Text("Your Prayers Request").font(.system(size: 35)).fontWeight(.heavy).padding(.top,75)
                    .onAppear{
                        viewModel.getUserPrayerRequest()
                    }

                    List{
                        ForEach(viewModel.userPrayers){ prayer in
                            VStack{
                                UserPrayers(prayer: prayer, prayerImage: viewModel.prayerImages)
                                    .onTapGesture {
                                        //
                                        self.prayer = prayer.prayer
                                        viewModel.getPrayerMessages(with: prayer.docID) { message in
                                            
                                            self.prayerMessage = message
                                            prayerMessageIsShowing = true
                                        }
                                        
                                    }
                            }
                            
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width).listRowBackground(Color.clear)
                
                // .overlay(Divider().background(.blue), alignment: .top)
                
            }//.background(Color(UIColor(named: "backgroundColor")!))
            
        }
            .sheet(isPresented: $prayerMessageIsShowing) {
                PrayerMessageView(prayerMessages: prayerMessage, prayer: prayer)
            }
    }
}

struct UserInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoScreen()
        PrayerMessageView(prayerMessages: ["Stay Strong", "Keep Fighting","You are loved! Please keep that in mind, Jesus loves you! \n 1 John 4:8"], prayer: "Please pray for me, I dont want to live anymore!")
    }
}

struct UserPrayers: View {
    @State var prayer: PrayerModel
    
    var prayerImage: [String:UIImage]?
    
    var defaultImage = UIImage(systemName: "photo")!
    
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
    
    var prayerMessages : [String]
    var prayer: String
    
    var body: some View {
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
        }.background()
        
    }
}
