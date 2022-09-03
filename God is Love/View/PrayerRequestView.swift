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
    @State private var prayerImage = UIImage(systemName: "photo")!
    @State private var userSelectedImage = false
    @State private var isShowingImagePhotoPicker = false

    
    @StateObject var viewModel = PrayerRequestViewModel()
    
    var body: some View {
        VStack{
            Spacer()

            if userSelectedImage == true{
                
                Image(uiImage:prayerImage)
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
                .foregroundColor(.blue)
            
            
            NameFieldView(name: $name)
            
            PrayerRequestFieldView(prayerInfo: $prayerInfo)
       
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
                    viewModel.uploadPrayerRequest(name: name, prayerRequest: prayerInfo, PrayerImage: prayerImage)
                    
                    
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
            
            Spacer()
            
        }.padding()
            .sheet(isPresented: $isShowingImagePhotoPicker, content: {
                PhotoPicker(profileImage: $prayerImage, userSelectedImage: $userSelectedImage)
                
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
                .font(.system(size: 20))
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(.blue, lineWidth: 4))
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
                    .frame(height: 20, alignment: .center)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue, lineWidth: 4)
                    )
                
                Text(text)
                    .opacity(0)
                    .padding(.all,8)
            }
            
        }
    }
}
