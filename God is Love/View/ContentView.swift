//
//  ContentView.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import SwiftUI
import AuthenticationServices
import CoreData

struct ContentView: View {
    

    @State private var status = ""
    @StateObject var loginData = LoginViewModel()
   
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                
                Text("God is Love")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.blue)
                
                Text("1 John 4:8")
                
                Spacer(minLength: 30)
                
                if loginData.login == true{
                    
                    NavigationLink("Need Prayers", destination: PrayerRequestView())
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    
                    NavigationLink("Pray for Others", destination: PrayersView())
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                
                    NavigationLink("User Info", destination: UserInfoScreen())
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    
                    Spacer()
                    
                    
                Button(action:{loginData.logOut()}, label:{Text("Logout")}).padding(.bottom,20)
                    
                }else{
                    Text(status).offset(y:-70)
                    
                    SignInWithAppleButton() { request in
                        loginData.nonce = randomNonceString()
                        request.requestedScopes = [.email]
                        request.nonce = sha256(loginData.nonce)
                        
                    } onCompletion: { result in
                        switch result{
                            
                            case .success(let user):
                                //login with firebase...
                                print("success")
                                loginData.login = true
                                status = ""
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{ print ("error with firebase"); return }
                                
                                loginData.authenticate(credential: credential)
                                
                            case .failure(let error):
                                status = "Login in Failed"
                                print(error.localizedDescription)
                            
                        }
                        
                    }.frame(width: 200, height: 50, alignment: .center)
                        .offset(y:-70)

                    
                }
            }
            
        }
        
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
