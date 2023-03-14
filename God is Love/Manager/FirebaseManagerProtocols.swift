//
//  FirebaseManagerProtocols.swift
//  God is Love
//
//  Created by Corey Edh on 2/19/23.
//
import FirebaseAuth
import FirebaseFirestore.FIRDocumentSnapshot

protocol FirebaseManagerProtocol: AuthenticationProtocol, UploadDataProtocol, GetDataProtocol{
    static var shared: FirebaseManager { get }
}

protocol AuthenticationProtocol{
    func firebaseCredential(idToken: String, nonce: String, loginCompletion: @escaping (Result<Bool,Error>)->())
    func logOutFromFirebase() -> Bool
}

extension AuthenticationProtocol{
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

protocol UploadDataProtocol{
    func addToFirebase(with reference: CollectionPaths, data: [String: Any], completion: @escaping ( Result<String, FirebaseManagerError> ) -> Void)
    func updateDataInFirebase(at reference: DocumentReference, data: [String:Any])
    func addImageToFireBase(storeAt: ImageStorage, image: UIImage)
}

protocol GetDataProtocol{
    func getFirebaseDataInCollection(for reference: CollectionReference, allowUserData: Bool, limitAmount: Int, completion: @escaping (Result<[[String:Any]], FirebaseManagerError>) -> Void)
    func getFirebaseDocumentData(for reference: DocumentReference, completion: @escaping (Result<[String:Any], FirebaseManagerError>) -> Void)
    func getFirebaseImage(id: String, completion: @escaping (Result<UIImage, FirebaseManagerError>) -> Void)
}
