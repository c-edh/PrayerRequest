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
    
    var body: some View {
        ZStack{
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:screenWidth, height:screenHeight)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            
            VStack{
                HStack{
                    VStack{
                        if let userImage = viewModel.user?.image{
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 100)
                        }else{
                            Image(systemName:"person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 100)
                        }
                        
                        Text("Hi \(viewModel.user?.name ?? "")")
                            .font(.system(size: 20,weight: .bold))
                    }.frame(maxHeight: .infinity,alignment: .bottom)
                        .padding([.leading])
                   
                    Spacer()
                    
                    Text("You Prayed for: **\(viewModel.user?.prayerCount ?? 0)**")
                        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
              
                }.frame(height: 200).frame(maxWidth: .infinity).padding()
                    .colorInvert().background(.primary.opacity(0.5)).colorInvert()
                    .border(width: 3, edges: [.bottom], color: .primary)
                
                VStack(spacing:30){
                    NavigationLink {
                        VStack{
                            Text("")
                        }
                    } label: {
                        Text("Your Friends").foregroundColor(.white)
                    }.padding()
                        .frame(width: 200,height: 50)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    NavigationLink {
                        ListOfUserPrayers()
                    } label: {
                        Text("Your Request").foregroundColor(.white)
                    }.frame(width: 200,height: 50).background(.black).clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Settings").foregroundColor(.white)
                    }.frame(width: 200,height: 50).background(.black).clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        viewModel.logOut()
                    } label: {
                        ButtonLabelView(labelText: "Logout")
                    }

                }.frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .top).padding()

            }.padding([.top])
            .navigationTitle("Your Prayers")
            .onAppear{
                viewModel.getUserData()
            }
        }
    }
}

struct UserInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoScreen()
    }
}
