//
//  PrayerRequestView.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import SwiftUI

struct PrayerRequestView: View {
    @State var friendsOnly: Bool = false {
        willSet{
            if newValue{ navigationTitleText = "To Everyone" }
            else{ navigationTitleText = "To Friends" }
        }
    }
    
    @State var navigationTitleText = ""
    @State var showRequest: Bool = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("backgroundCross.png")
                    .resizable().aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: 25)
                    .offset(x: 500, y:-6)
//                if showRequest == true{
                    VStack{
                        Text("Who do you want to Pray for you?")
                            .padding()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .font(.system(size: 40))
                        Button {
                            friendsOnly = true
                            showRequest = false
                            
                        } label: {
                            Text("Everyone")
                                .padding()
                                .frame(width:120,height:50)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }.padding()
                        
                        NavigationLink {
                            GetPrayerRequestView(from: friendsOnly)
                        } label: {
                            Text("Friends")
                                .padding()
                                .frame(width:120,height:50)
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        
                        Button {
                            //
                            friendsOnly = true
                            showRequest = true
                            
                        } label: {
                     
                        }
                    }
//                } else{
//                    GetPrayerRequestView(from: friendsOnly)
//                }
            }.padding().background(Color(UIColor(named: "backgroundColor")!))
        }
    }
}

struct PrayerRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerRequestView()
    }
}

struct NameFieldView: View {
    
    @Binding var name: String
    @Binding var isFocus: Bool
    
    var body: some View {
        HStack{
            Text("For:")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .shadow(radius: 16)
                .padding(16)
            
            TextField("Anonymous",text:$name)
                .font(.system(size: 20)).padding()
                .frame(height: 50)
                .background(.black)
                .foregroundColor(.white).cornerRadius(16)
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
                .shadow(radius: 16)
            
            ZStack{
             
                TextEditor(text: $prayerInfo)
                    .scrollContentBackground(.hidden) // <- Hide it
                    .background(.black) // To see this
                    .font(.system(size:20))
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .keyboardType(.asciiCapable)
                
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

            
        }.padding().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct GetPrayerRequestView: View {
    
    @StateObject var viewModel = PrayerRequestViewModel()
    @State private var prayerInfo: String = ""
    @State private var name = ""
    @State private var prayerImage: UIImage?
    @State private var userSelectedImage = true
    @State private var isShowingImagePhotoPicker = false
    @State private var nameisFocus = false
    @State private var prayIsFocus = false
    @State private var showSubmission = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let from: Bool

    var body: some View {
        VStack{
            
            if viewModel.messageIsSuicidal{
                SuicidalHelpView()
            }else{
                Spacer()
                ZStack{
                    if prayerImage == nil{
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .clipShape(Circle())
                            .overlay(content: {
                                Circle()
                                    .stroke(lineWidth: 3)
                                    .shadow(radius: 16)
                            })
                            .padding(.bottom)
                            .onTapGesture {
                                isShowingImagePhotoPicker = true
                            }
                        Image(systemName: "plus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .colorInvert()
                            .frame(width: 50)
                            .shadow(radius: 16)
                        .offset(x:40, y: 50)
                        .onTapGesture {
                            isShowingImagePhotoPicker = true
                        }
                        
                    }else{
                        Image(uiImage:(prayerImage!))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .clipShape(Circle())
                                .overlay(content: {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .shadow(radius: 16)
                                })
                                .padding(.bottom)
                                .onTapGesture {
                                    isShowingImagePhotoPicker = true
                                }
                                  
                        Image(systemName: "minus.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                            .frame(width: 50)
                            .shadow(radius: 16)
                        .offset(x:60, y: 70)
                        .onTapGesture {
                            prayerImage = nil
                        }
                    }
                }
                
                Text("Prayer Request")
                    .font(.title)
                    .fontWeight(.heavy)
                    .shadow(radius: 16)
                
                
                NameFieldView(name: $name, isFocus: $nameisFocus)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width)
                
                PrayerRequestFieldView(prayerInfo: $prayerInfo)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width)
                

                Spacer()
                Button(
                    action:{
                        viewModel.addUserPrayerRequest(name: name, prayerRequest: prayerInfo, prayerImage: prayerImage)
                        
                        showSubmission = true
                    },
                    label: {
                        Text("Submit")
                            .frame(width: 100, height: 20, alignment: .center)
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            
                            
                            .cornerRadius(10)
                    })
                Spacer()
            }
        }
        .onTapGesture {
            nameisFocus = false
            prayIsFocus = false
        }
        .alert("Your Prayer has been submitted", isPresented: $showSubmission, actions: {
            Button("Ok"){
                dismiss()
            }
        })
        .sheet(isPresented: $isShowingImagePhotoPicker, content: {
            PhotoPicker(profileImage: $prayerImage, userSelectedImage: $userSelectedImage)
                .shadow(radius: 16)
            
        })
    }
}
