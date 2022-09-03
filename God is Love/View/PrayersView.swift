//
//  Prayers.swift
//  God is Love
//
//  Created by Corey Edh on 8/24/22.
//

import SwiftUI

struct PrayersView: View {
    
    @StateObject var viewModel = PrayersViewModel()
    @State var prayAdviceIsShowing = false
    @State private var profileImage = UIImage(systemName: "photo")!


    var body: some View {
        VStack{
            
            if viewModel.hasImage{
                Image(uiImage:profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .cornerRadius(100)
            }
            
            
            PrayerView(name: viewModel.getPrayer().name,
                       date: viewModel.getPrayer().date,
                       prayer: viewModel.getPrayer().prayer)
            .onAppear{
                viewModel.getPrayersRequest()
                viewModel.getPrayer()
            }
            
            if prayAdviceIsShowing{
                PrayerAdvice(isOpen: $prayAdviceIsShowing,
                             viewModel: viewModel)
            }else{
                
                if viewModel.hasImage{
                    Image(uiImage:profileImage)
                        .frame(width: 300,height: 300)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(100)
                    
                }
                
                NextAndPrayButton(prayAdviceIsShowing: $prayAdviceIsShowing, viewModel: viewModel)
                
            }
            
        }
        
    }
    
}

struct PrayersView_Previews: PreviewProvider {
    static var previews: some View {
        PrayersView()
    }
}

struct PrayerAdvice:View{
    
    @State private var encouragement = ""
    @State private var textHintIsShowing = true
    
    @Binding var isOpen: Bool
    
    var viewModel : PrayersViewModel
    
    var body: some View{
        VStack{
            Text("Message to the Person that needs the Prayer" )
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            ZStack{
                
                TextEditor(text: $encouragement)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 4)).padding()
                .onTapGesture {
                    textHintIsShowing = false
                }
                if textHintIsShowing{
                Text("Words of Encouragement").foregroundColor(.blue)
                    .onTapGesture {
                        textHintIsShowing.toggle()
                    }
                    
                }
            
        }
            Button(action:{
                if viewModel.prayers.peek() != nil{
                    viewModel.userPray(encouragement)
                    print("send button pressed")
                }
                
                isOpen.toggle()
                
            }, label:{
                Text("Send").frame(width: 200, height: 50, alignment: .center).background(.blue).foregroundColor(.white).cornerRadius(16)
            })
            
        }.padding().overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 4))
        
        
        
        
    }
}

struct PrayerView: View {
    let name: String
    let date: String
    let prayer: String
    
    var body: some View {
        VStack{
            HStack{
                HStack{
                    Text("For")
                    Text(name)
                }.font(.system(size: 25).bold())
                
                Spacer()
                Text(date)
            }
            .foregroundColor(.blue)
            .padding()
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            
            ScrollView{
                
                Text(prayer)
                    .font(.system(size: 35)).fontWeight(.bold).foregroundColor(.blue)
                
            }
            Spacer()
        }
    }
}

struct NextAndPrayButton: View {
    
    @Binding var prayAdviceIsShowing: Bool
    @State   var viewModel: PrayersViewModel
    
    var body: some View {
        HStack{
            Button(action: {
                //Pop from the Stack
                if viewModel.prayers.peek() != nil{
                    viewModel.userSkip()
                }
                
                
            }, label: {
                Text("Next")
            })
            Spacer()
            Button(action: {
                prayAdviceIsShowing.toggle()
                //Allow Prayer to Send a message to Requestor
                
            }, label: {
                Text("Pray")
                    .frame(width:100,height: 50)
                    .background(.blue).foregroundColor(.white)
                    .cornerRadius(16)
            })
        }.font(.system(size: 20).bold()).padding(30)
    }
}
