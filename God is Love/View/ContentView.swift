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
            ZStack{
                Image("backgroundCross.png")
                    .resizable().aspectRatio(contentMode: .fill)
                    .frame(width:UIScreen.main.bounds.height,height:UIScreen.main.bounds.height)
                    .offset(x: 500, y:-6)
                
                VStack{
                    Spacer()
                    
                    Text("James\n5:15-16")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                       // .foregroundColor(.black)
                        .shadow(radius: 3)
                    
                    Spacer(minLength: 30)
                    
                    //Change back to true when done editing
                    if loginData.login == false{
                        StartMenu(loginData: loginData)
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(16).shadow(radius: 16)
                        Spacer()
                        
                        
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
    
    var loginData : LoginViewModel
    
    var body: some View {
        
        ZStack{
            
            VStack{
                NavigationLink("Ask for Prayers", destination: PrayerRequestView())
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.bottom,25)
                
                NavigationLink("Pray for Others", destination: PrayersView())
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)

                
                NavigationLink("Your Prayers", destination: UserInfoScreen())
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(25)
                
                Button(action:{
                    loginData.logOut()
                }, label:{Text("Logout").frame(width: 100, height: 50, alignment: .center).background(.black).foregroundColor(.white).cornerRadius(16).padding()})
                
            }.shadow(radius: 16)
            
            NavigationLink(destination: {
                UserInfoScreen()
            }, label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }).offset(x:150,y:-500)

            
        }
    }
}
