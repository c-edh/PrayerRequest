//
//  ListOfUserPrayers.swift
//  God is Love
//
//  Created by Corey Edh on 3/4/23.
//

import SwiftUI


struct ListOfUserPrayers: View {
    
    @StateObject var viewModel = UserInfoScreenViewModel()
    @State var prayer: PrayerModel?
    @State var prayerMessagesAreShowing : Bool = false
    
    var body: some View {
        VStack{
            if let prayers = viewModel.userPrayers{
                ScrollView{
                ForEach(prayers){ prayer in
                    LazyVStack{
                        NavigationLink {
                            PrayerMessageView(prayerMessages: viewModel.messageForPrayer, prayer: prayer.prayer)
                        } label: {
                            UserPrayers(prayer: prayer)
                                .onTapGesture {
                                    self.prayer = prayer
                                    prayerMessagesAreShowing = true
                                }
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }}
                }.frame(width: UIScreen.main.bounds.width).listRowBackground(Color.clear)
            }
            else{
                Text("You have no Prayers Request").frame(maxWidth: .infinity).background(.black)
                }
        }.padding([.top,.bottom])
            .onAppear{ Task{ await viewModel.getUserPrayerRequest() } }
    }
}


struct UserPrayers: View {
    @State var prayer: PrayerModel
    
    var body: some View {
        HStack{
            VStack{
                    Text(prayer.date) //prayer.date
                    .frame(maxWidth: .infinity,alignment: .trailing)
                
                Text(prayer.prayer)
                    .frame(maxWidth: .infinity,alignment: .leading)//prayer.prayer
                HStack{
                    Text("Amount of Prayers").font(.caption)
                    Text(String(prayer.prayerCount)).fontWeight(.bold) //prayer.count
                }
                .frame(maxWidth: .infinity,alignment: .bottomLeading).padding()
                
            }.foregroundColor(.white)
            if (prayer.image != nil){
                Image(uiImage:(prayer.image)!)
                    .resizable().aspectRatio(contentMode: .fit).frame(width:100).cornerRadius(100)
                
            }
        }
        .padding().frame(width: UIScreen.main.bounds.width-50)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 4).foregroundColor(.white))
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
                    .font(.system(size:30))
                    .fontWeight(.heavy)
                    .padding()
                if !prayerMessages.isEmpty{
                    ScrollView{
                    ForEach(prayerMessages, id:\.self){ message in
                        LazyVStack{
                            Text(message)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .foregroundColor(.white)
                            
                            Button(action:{
                                //Report User comments
                            }){
                                Text("Report")
                                    .padding()
                                    .frame(maxWidth: .infinity,alignment: .trailing)
                            }
                            
                        }.padding([.leading,.trailing,.top]).background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 6)
                            .padding([.trailing,.leading])
                        
                    }
                }.frame(maxWidth: .infinity)
                }else{
                    Text("This Prayer Request has no messages").foregroundColor(.primary).padding()}
                Spacer()
            }.padding(.top,30)
        }
    }
}



struct ListOfUserPrayers_Previews: PreviewProvider {
    static var previews: some View {
        ListOfUserPrayers()
        PrayerMessageView(prayerMessages: ["Stay Strong", "Keep Fighting","You are loved! Please keep that in mind, Jesus loves you! \n 1 John 4:8"], prayer: "Please pray for me, I dont want to live anymore!")
    }
}
