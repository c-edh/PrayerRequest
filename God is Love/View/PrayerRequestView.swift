//
//  PrayerRequestView.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import SwiftUI

struct PrayerRequestView: View {
    
    @State private var prayerInfo: String = ""
    @State private var name = ""
    @State private var prayerImage: UIImage?
    @State private var userSelectedImage = false
    @State private var isShowingImagePhotoPicker = false
    //  @State private var dismissMessage = false
    
    
    @StateObject var viewModel = PrayerRequestViewModel()
 
    
    var body: some View {
        ZStack{
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.height,
                       height:UIScreen.main.bounds.height)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
        
            VStack{
                
                if viewModel.messageIsSuicidal{
                    SuicidalHelpView()
                }else{
                    Spacer()
                    
                    
                    if userSelectedImage{
                        
                        Image(uiImage:prayerImage ?? UIImage(named: "photo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .cornerRadius(100)
                            .shadow(radius: 16)
                            .padding(.bottom)
                        
                    }
                    
                    
                    Text("Prayer Request")
                        .font(.title)
                        .fontWeight(.heavy)
                        //.foregroundColor()
                    
                    
                    NameFieldView(name: $name)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width)
                    
                    PrayerRequestFieldView(prayerInfo: $prayerInfo)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width)
                    
                    Button(
                        
                        action:{
                            if userSelectedImage != true{
                                isShowingImagePhotoPicker = true
                                
                            }else{
                                userSelectedImage = false
                            }
                        },
                        
                        label:{
                            Text(userSelectedImage ? "Remove Image" : "Add Image")
                                .frame(width:100,height:50)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.bottom,50)
                        }
                    )
                    
                    
                    Button(
                        action:{
                            
                            viewModel.getUserPrayerRequest(name: name, prayerRequest: prayerInfo, prayerImage: prayerImage)
//                            viewModel.uploadPrayerRequest(name: name,
//                                                          prayerRequest: prayerInfo,
//                                                          prayerImage: prayerImage)
                            
                            
                        },
                        label: {
                            Text("Send Prayer Request")
                                .frame(width: 170, height: 20, alignment: .center)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    
                    Spacer()}
            }
            
            
        }.padding().background(Color(UIColor(named: "backgroundColor")!))
            .sheet(isPresented: $isShowingImagePhotoPicker, content: {
                PhotoPicker(profileImage: $prayerImage, userSelectedImage: $userSelectedImage)
                    .shadow(radius: 16)
                
            })
    }
}

struct PrayerRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerRequestView()
    }
}

struct NameFieldView: View {
    
    @Binding var name: String
    
    var body: some View {
        HStack{
            Text("For:")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(16)
            
            TextField("Anonymous",text:$name)
                .font(.system(size: 20)).padding()
                .frame(height: 50)
                .background(.black)
                .foregroundColor(.white).cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 4))
        }
    }
}




struct PrayerRequestFieldView: View {
    
    @Binding var prayerInfo: String
    
    @State private var text = ""
    
   
    
    var body: some View {
        HStack{
            
            Text("Prayer:")
                .font(.system(size: 22))
                .fontWeight(.bold)
            
            ZStack{
                
                TextEditor(text: $prayerInfo)
                    .font(.system(size:20))
                    .padding()
                    .frame(height: 50)
                    .background(.black)  // light mode black todo, darkmode white
                    .foregroundColor(.white)
                    .cornerRadius(16)
//                    .overlay(RoundedRectangle(cornerRadius: 16)
//                        .stroke(lineWidth: 4).opacity(0)
//
//                    )
                
                Text(text).background(.black)
                    .opacity(0)
                    .padding(.all,8)
                
            }
            
        }
    }
}

struct SuicidalHelpView: View {
    
    private let bibleVerses = [
        ["\"Today I have given you the choice between life and death, between blessings and curses. Now I call on heaven and earth to witness the choice you make. Oh, that you would choose life, so that you and your descendants might live!\nYou can make this choice by loving the Lord your God, obeying him, and committing yourself firmly to him. This is the key to your life\"","Deuteronmy 30:19-20"],
        ["\"Cast your burden on the Lord, and he will sustain you; he will never permit the righteous to be moved\"","Psalm 55:22"],
        ["\"Casting all your anxieties on him, because he cares for you\"","Peter5:7"],
        ["\"When the righteous cry for help, the Lord hears and delivers them out of all their troubles.\"","Psalm 34:17"],
        ["\"Even though I walk through the valley of the shadow of death, I will fear no evil, for you are with me; your rod and your staff, they comfort me.\"","Psalm 23:4"],
        ["\"Have I not commanded you? Be strong and courageous. Do not be frightened, and do not be dismayed, for the Lord your God is with you wherever you go.\"","Joshua 1:9"]
    ]
    
    private let personalHiddenEmail = "revises_billow07@icloud.com"
    
    var body: some View {
        VStack{
            let randomVerse = bibleVerses.randomElement()!
            
            Text(randomVerse[0]).fontWeight(.heavy).font(.system(size: 25)).minimumScaleFactor(0.5)
                .shadow(radius:10)
            
            Text(randomVerse[1]).padding(.bottom,8)
            
            VStack{
                Text("Please reach out! you are loved!").font(.system(size: 25)).fontWeight(.heavy).padding(3)
                    .frame(width: UIScreen.main.bounds.width,alignment: .leading)
                    //.shadow(radius: 3)
                
                Button(action:{
                    // dismissScreen.toggle()
                    
                }){
                    HStack{
                        Text("The USA Suicide Hotline").font(.system(size: 25))
                        Text("988").font(.system(size: 50)).fontWeight(.heavy)
                    }
                    
                }}
            
          
            
            
           
            
            
           
            
            
       
            
            VStack{
                Text("No luck with the hotline? My Email:")
                
                Button(action: {
                    //Email me
                }, label: {
                    Text(personalHiddenEmail)
                })
                
            }.font(.system(size: 20)).padding([.bottom,.top], 10)
            
      
            
            
           
            
        }.padding().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
