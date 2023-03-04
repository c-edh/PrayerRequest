//
//  ButtonLabelView.swift
//  God is Love
//
//  Created by Corey Edh on 3/4/23.
//

import SwiftUI

struct ButtonLabelView: View {
    let labelText: String
    var body: some View {
        Text(labelText)
            .frame(width:100,height: 50)
            .background(.black).foregroundColor(.white)
            .cornerRadius(16)
    }
}

struct ButtonLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLabelView(labelText: "Hi")
    }
}
