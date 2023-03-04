//
//  CustomTextFieldView.swift
//  God is Love
//
//  Created by Corey Edh on 3/4/23.
//

import SwiftUI

struct CustomTextFieldView: View {
    
    let label: String
    let hint: String
    @Binding var text: String
    
    var body: some View {
        HStack{
            Text(label)
                .font(.system(size: 22))
                .fontWeight(.bold)
                .shadow(radius: 16)
                .padding(16)
            
            TextField(hint,text:$text)
                .font(.system(size: 20)).padding()
                .frame(height: 50)
                .background(.black)
                .foregroundColor(.white).cornerRadius(16)
        } .padding()
            .frame(width: UIScreen.main.bounds.width)
    }
}

struct CustomTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldView(label: "Name", hint: "Your name", text: .constant("hi"))
    }
}
