//
//  LoginViewModel.swift
//  God is Love
//
//  Created by Corey Edh on 8/26/22.
//

import Foundation
import CryptoKit
import AuthenticationServices
import Firebase

class LoginViewModel: ObservableObject{
    @Published var nonce = ""
    @Published var login = false
    
    private let firebaseManager = FirebaseManager.shared
    
    func authenticate(credential: ASAuthorizationAppleIDCredential){
        guard let token = credential.identityToken else{
            print("error with identityToken")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("Token error")
            return
        }

        firebaseManager.firebaseCredential(idToken: tokenString, nonce: nonce){ [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.login = success
                }
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    func setUpAccount(name: String){
        guard let user = Auth.auth().currentUser else{
            print("No current user")
            return
        }
        let data = ["Name": name, "FriendsCount": 0, "Image": "", "PrayerCount": 0] as [String: Any]
        self.firebaseManager.addToFirebase(with: .UserCollection(.User(user)), data: data) { _ in }
    }
    
    func logOut(){
        DispatchQueue.main.async {
            self.login = self.firebaseManager.logOutFromFirebase()
        }
    }
}


//MARK: - Encryption

func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}


func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

  return result
}
