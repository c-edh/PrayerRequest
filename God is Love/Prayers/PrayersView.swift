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
    @Environment(\.colorScheme) private var colorScheme

    
    var body: some View {
        ZStack{
            Image("backgroundCross.png")
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.height,
                       height:UIScreen.main.bounds.height)
                .blur(radius: 25)
                .offset(x: 500, y:-6)
            
            //            if viewModel.getPrayer() == nil{
            //
            //                OutOfPrayersView(viewModel: viewModel)
            //
            //            }else{
            VStack{
                Button("Report"){
                    print("test")
                }.foregroundColor(.blue).frame(maxWidth: .infinity,alignment: .trailing).padding([.top,.trailing,.leading]).buttonStyle(.bordered).shadow(radius: 1)
                PrayerView(prayer: viewModel.prayer)
                    .padding()
                
                
                
                NextAndPrayButton(prayAdviceIsShowing: $prayAdviceIsShowing, viewModel: viewModel)
                Spacer()
                    .frame(height: 25.0)
                
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .sheet(isPresented: $prayAdviceIsShowing) {
                    PrayerAdvice(isOpen: $prayAdviceIsShowing,
                                 viewModel: viewModel) .presentationDetents([.medium, .fraction(0.3)])
                        .background(colorScheme == .dark ? Color(hue: 1.0, saturation: 0.0, brightness: 0.6): Color(red: 0.995, green: 0.908, blue: 0.751))
                      
                }
            // }
            
        }.onAppear{
            viewModel.getPrayersRequest()
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
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            ZStack{
                
                TextEditor(text: $encouragement)
                // .overlay(RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 4))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 5)
                    .padding()
                    .onTapGesture {
                        textHintIsShowing = false
                    }
                    .focused($focusedField, equals: .encouragement)
                if textHintIsShowing{
                    Text("Words of Encouragement")
                        .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.605))
                        .onTapGesture {
                            textHintIsShowing.toggle()
                        }
                    
                }
                
            }
            Button(action:{
                viewModel.userPray(encouragement)
                isOpen.toggle()
                
            }, label:{
                Text("Send").frame(width: 200, height: 50, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 16)
            })
            .toolbar{
                ToolbarItem(placement: .keyboard){
                    Button("Done"){
                        focusedField = nil
                    }
                }
            }
        }.padding()
    }
}

struct PrayerView: View {
    
    let prayer: PrayerModel?
    
    var body: some View {
        
        VStack{
            Spacer()
                .frame(height: 20.0)
            if let image = prayer?.image{
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
                    Text(prayer?.name ?? "Anoynmous")
                }.font(.system(size: 25).bold())
                
                Spacer()
                Text(prayer?.date ?? "N/A")
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            
            ScrollView{
                
                Text(prayer?.prayer ?? "No Prayer")
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                
            }
            
            
            
        }
    }
}

struct NextAndPrayButton: View {
    
    @Binding var prayAdviceIsShowing: Bool
    @State   var viewModel: PrayersViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack{
            Button(action: {
                //Pop from the Stack
                prayAdviceIsShowing.toggle()
            }, label: {
                Text("Send Message")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .fontWeight(.bold)
            })
            Spacer()
            Button(action: {
                viewModel.userPray()
            }, label: {
                Text("Pray")
                    .frame(width:100,height: 50)
                    .background(.black).foregroundColor(.white)
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
