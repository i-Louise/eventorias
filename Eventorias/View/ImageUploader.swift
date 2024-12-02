//
//  ImageUploader.swift
//  Eventorias
//
//  Created by Louise Ta on 11/11/2024.
//

import Foundation
import FirebaseStorage

struct ImageUploader {
    
    static func uploadImage(path: String, image: Data, completion: @escaping (String) -> Void) {
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: path + fileName)
        
        ref.putData(image, metadata: nil) { metadata, error in
            if let error = error {
                print("Err: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageURL = url?.absoluteString else {return}
                completion(imageURL)
            }
        }
    }
}
