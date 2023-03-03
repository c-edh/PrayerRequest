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
    func addToFirebase(with reference: Collection, data: [String: Any], completion: @escaping (_ documentReference: String) -> Void)
    func updateDataInFirebase(at location: Collection, data: [String:Any])
    func addImageToFireBase(documentId: String, image: UIImage)
}

protocol GetDataProtocol{
    func getFirebaseDataInCollection(for reference: CollectionReference, allowUserData: Bool, limitAmount: Int, completion: @escaping (Result<[[String:Any]], FirebaseManagerError>) -> Void)
    func getFirebaseDocumentData(for reference: Collection, completion: @escaping (Result<[String:Any], FirebaseManagerError>) -> Void)
    func getFirebaseImage(id: String, completion: @escaping (Result<UIImage, FirebaseManagerError>) -> Void)
}
