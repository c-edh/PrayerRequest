//
//  PhotoPicker.swift
//  God is Love
//
//  Created by Corey Edh on 9/1/22.
//


import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable{
    
    @Binding var profileImage: UIImage?
    @Binding var userSelectedImage: Bool

    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage{
                guard let data = image.jpegData(compressionQuality: 0.4), let compressedImage = UIImage(data: data) else{
                    
                    //error
                    
                    return
                }
                
                photoPicker.profileImage = compressedImage
                photoPicker.userSelectedImage = true
                
            }else{
                //Return show the user mess up
                print("Photo mess up")
            }
            picker.dismiss(animated: true)
        }
    }
        
    
    
}
