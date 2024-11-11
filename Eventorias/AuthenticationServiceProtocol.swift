//
//  AuthenticationServiceProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import Foundation

protocol AuthenticationServiceProtocol: AnyObject {
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    func registration(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
}
