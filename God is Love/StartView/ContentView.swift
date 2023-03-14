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
    @AppStorage("accountSetUp") var accountSetUp = false
    
    var body: some View {
        NavigationView{
            
            if loginData.login == true && !accountSetUp{
                SetUPView(viewModel: loginData, setupComplete: $accountSetUp)
           }
            else if loginData.login == false{ StartMenu() }
            
            else{
                ZStack{
                    Image("backgroundCross.png")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:UIScreen.main.bounds.height,
                               height:UIScreen.main.bounds.height)
                        .offset(x: 500, y:-6)
                    
                    VStack{
                        Spacer()
                        
                        Text("God is Love")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 50))
                            .fontWeight(.heavy)
                            .shadow(radius: 3)
                        
                        Spacer(minLength: 30)
                        
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
                PrayerRequestView()
                    .tabItem { Label("Request", systemImage: "shift.fill") }
                PrayersView()
                    .tabItem { Label("Prayers", systemImage: "person.3.fill") }
                UserInfoScreen()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            }
        }
    }
}


struct SetUPView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State var image: UIImage?
    @State var name = ""
    @State var email = ""
    
    @Binding var setupComplete: Bool
    var body: some View {
        ZStack{
            
            Image("backgroundCross.png")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:UIScreen.main.bounds.height,
                       height:UIScreen.main.bounds.height)
                .offset(x: 500, y:-6)
            
            VStack{
                Spacer()
                ImageSelectorView(image: $image).padding()
                CustomTextFieldView(label: "Name", hint: "Your Name", text: $name)
                Text("Optinal Info\n(Only your friends will see)").font(.caption)
                Button {
                    viewModel.setUpAccount(name: name, image: image) { accountCreated in
                        DispatchQueue.main.async { self.setupComplete = accountCreated }
                    }
                    
                } label: {
                    ButtonLabelView(labelText: "Create")
                }.padding()
                Spacer()                
            }
        }
    }
}
