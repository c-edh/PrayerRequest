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
    @State private var profileImage:UIImage?
    
    
    var body: some View {
        ZStack{
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.height,
                       height:UIScreen.main.bounds.height)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            
            if viewModel.getPrayer() == nil{
                
                OutOfPrayersView(viewModel: viewModel)
                
            }else{
                VStack{
                        PrayerView(
                            hasImage:viewModel.hasImage,
                            image:viewModel.PrayerImage[viewModel.getPrayer()!.docID],
                            name: viewModel.getPrayer()!.name,
                            date: viewModel.getPrayer()!.date,
                            prayer: viewModel.getPrayer()!.prayer
                        ).padding()
                        
                    
                    if prayAdviceIsShowing{
                        PrayerAdvice(isOpen: $prayAdviceIsShowing,
                                     viewModel: viewModel)
                    }else{
                        
                        NextAndPrayButton(prayAdviceIsShowing: $prayAdviceIsShowing, viewModel: viewModel)
                        Spacer()
                            .frame(height: 25.0)
                        
                    }
                    
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                // .background(Color(UIColor(named: "backgroundColor")!))
                
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
    
    private enum Field: Int, CaseIterable {
            case encouragement
        }
    
    @State private var encouragement = ""
    @State private var textHintIsShowing = true
    
    @Binding var isOpen: Bool
    @FocusState  private var focusedField: Field?
    
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
                    .focused($focusedField, equals: .encouragement)
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
            .toolbar{
                ToolbarItem(placement: .keyboard){
                    Button("Done"){
                        focusedField = nil
                    }
                }
            }
        }.padding().overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 4))
        
        
        
        
    }
}

struct PrayerView: View {
    let hasImage: Bool
    let image: UIImage?
    let name: String
    let date: String
    let prayer: String
    
    var body: some View {
        
        VStack{
            Spacer()
                .frame(height: 20.0)
            if let image = image{
                Image(uiImage:image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .cornerRadius(100)
                    .shadow(radius: 16)
            }
            
            HStack{
                HStack{
                    Text("For")
                    Text(name)
                }.font(.system(size: 25).bold())
                
                Spacer()
                Text(date)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            
            ScrollView{
                
                Text(prayer)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                
            }
            
            
            
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

struct OutOfPrayersView: View {
    
    var viewModel : PrayersViewModel
    
    var body: some View {
        VStack{
            Spacer()
            Text("All prayers have been prayed for. Thank you")
                .fontWeight(.heavy).font(.system(size: 50))
                .foregroundColor(.blue)
                .padding()
            Spacer()
            
            Button(action:{}) {
                Text("Check for new Prayers").frame(width: 200, height: 50, alignment: .center).foregroundColor(.white).background(.blue).cornerRadius(16)
            }
            Spacer()
            
        }.onAppear{
            viewModel.getPrayersRequest()
            viewModel.getPrayer()
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).background(Color(UIColor(named: "backgroundColor")!))
    }
}
