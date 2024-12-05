//
//  ImageUploaderProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 05/12/2024.
//

import Foundation

protocol ImageUploaderProtocol {
    func uploadImage(path: String, image: Data, completion: @escaping (String?, Error?) -> Void)
}
