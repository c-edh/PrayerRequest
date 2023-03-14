//
//  PrayerRequestView.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import SwiftUI

struct PrayerRequestView: View {
    @State var friendsOnly: Bool = false
        
    var body: some View {
        NavigationStack{
            ZStack{
                Image("backgroundCross.png")
                    .resizable().aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: 25)
                    .offset(x: 500, y:-6)
                VStack{
                    Text("Who do you want to Pray for you?")
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .font(.system(size: 40))
                    
                    NavigationLink { GetPrayerRequestView(from: friendsOnly) }
                label: { ButtonLabelView(labelText: "Everyone") } .padding()
                    
                    NavigationLink { GetPrayerRequestView(from: friendsOnly) }
                label: { ButtonLabelView(labelText: "Friends") }
                }
            }.background(Color(UIColor(named: "backgroundColor")!))
        }
    }
}

struct PrayerRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerRequestView()
        SuicidalHelpView()
    }
}

struct GetPrayerRequestView: View {
    
    @StateObject var viewModel = PrayerRequestViewModel()
    @State private var prayerInfo: String = ""
    @State private var name = ""
    @State private var prayerImage: UIImage?
    @State private var isShowingImagePhotoPicker = false
    @State private var showSubmission = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let from: Bool
    
    var body: some View {
        ZStack{
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            VStack{
                
                if viewModel.messageIsSuicidal{
                    SuicidalHelpView()
                }else{
                    Spacer()
                    
                    ImageSelectorView(image: $prayerImage)
                    
                    Text("Prayer Request")
                        .font(.title)
                        .fontWeight(.heavy)
                        .shadow(radius: 16)

                    CustomTextFieldView(label: "For:", hint: "Annonymous", text: $name)
                    
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
                        .padding()
                        .frame(width: UIScreen.main.bounds.width)
                    
                    Spacer()
                    Button(
                        action:{
                            viewModel.addUserPrayerRequest(name: name, prayerRequest: prayerInfo, prayerImage: prayerImage)
                            showSubmission = true
                        },
                        label: { ButtonLabelView(labelText: "Submit") }
                    )
                    
                    Spacer()
                }
            }
            .alert("Your Prayer has been submitted", isPresented: $showSubmission, actions: { Button("Ok"){ dismiss() } })
            
          
        }
        .background(Color(UIColor(named: "backgroundColor")!))
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

