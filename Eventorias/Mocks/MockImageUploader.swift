//
//  MockImageUploader.swift
//  EventoriasTests
//
//  Created by Louise Ta on 05/12/2024.
//

import Foundation

class MockImageUploader: ImageUploaderProtocol {
    var shouldFail = false
    var imageUploaded = false
    var imageUrl: String?
    
    func uploadImage(path: String, image: Data, completion: @escaping (String?, Error?) -> Void) {
        if shouldFail {
            let error = NSError(domain: "MockImageUploader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload image"])
            completion(nil, error)
        } else {
            completion("https://example.com/image.jpg", nil)
            imageUploaded = true
        }
    }
}
