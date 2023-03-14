//
//  ImageSelectorView.swift
//  God is Love
//
//  Created by Corey Edh on 3/4/23.
//

import SwiftUI

struct ImageSelectorView: View {
    @Binding var image: UIImage?
    
    @State var isShowingImagePhotoPicker = false
    @State private var userSelectedImage = true

    
    var body: some View {
        ZStack{
            if image == nil{
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
                Image(uiImage:(image!))
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
                        image = nil
                    }
            }
               
        } .sheet(isPresented: $isShowingImagePhotoPicker, content: {
            PhotoPicker(image: $image, userSelectedImage: $userSelectedImage)
                .shadow(radius: 16)
        
        })
    }
}


struct ImageSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectorView(image: .constant(nil))
    }
}
