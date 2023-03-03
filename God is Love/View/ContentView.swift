//
//  ContentView.swift
//  God is Love
//
//  Created by Corey Edh on 8/23/22.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    
    @StateObject var loginData = LoginViewModel()

    @State private var status = ""
    
    var body: some View {
        
        NavigationView{
            if loginData.login == true{
                StartMenu()
            }
            else{
            ZStack{
                Image("backgroundCross.png")
                    .resizable().aspectRatio(contentMode: .fill)
                    .frame(width:UIScreen.main.bounds.height,height:UIScreen.main.bounds.height)
                    .offset(x: 500, y:-6)
                
                VStack{
                    Spacer()
                    
                    Text("God is Love")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .shadow(radius: 3)
                    
                    Spacer(minLength: 30)
                    
                    //Change back to true when done editing
                 
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
                            
                        }.shadow(radius: 16).frame(width: 200, height: 50, alignment: .center)
                            .offset(y:-150)
                    }
                }
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().preferredColorScheme(.dark)
    }
}

struct StartMenu: View {
    var body: some View {
    
        ZStack{
            TabView {
                
                PrayerRequestView().tabItem {
                    Label("Request", systemImage: "shift.fill")
                }
                
                PrayersView().padding()
                    .tabItem {
                        Label("Prayers", systemImage: "person.3.fill")
                    }
                
                UserInfoScreen()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                
            }
            
            
            
        }
            
        }
}

