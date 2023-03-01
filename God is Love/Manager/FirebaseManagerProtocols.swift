//
//  FirebaseManagerProtocols.swift
//  God is Love
//
//  Created by Corey Edh on 2/19/23.
//
import FirebaseAuth
import FirebaseFirestore.FIRDocumentSnapshot

protocol FirebaseManagerProtocol: LoginProtocol, UserProtocol{
    static var shared: FirebaseManager { get }
}

protocol LoginProtocol{
    func firebaseCredential(idToken: String, nonce: String, loginCompletion: @escaping (Result<Bool,Error>)->())
    func setUpUser(userInfo: [String: Any])
    func logOutFromFirebase() -> Bool
}

extension LoginProtocol{
    func firebaseCredential(idToken: String, nonce: String, loginCompletion: @escaping (Result<Bool,Error>)->()){
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idToken, rawNonce: nonce)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error{
                print(error.localizedDescription)
                loginCompletion(.failure(error))
                return
            }
            loginCompletion(.success(true))
        }
    }
    
    func logOutFromFirebase() -> Bool{
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            return true
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return false
        }
    }
}

protocol UserProtocol{
    func getUserPrayerRequestMessages(for prayerID: String, completion: @escaping (Result<[String], FirebaseManagerError>) -> Void)
}

