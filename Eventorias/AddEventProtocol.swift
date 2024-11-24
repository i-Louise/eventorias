//
//  AddEventProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation

protocol AddEventProtocol {
    func addEvent(event: EventRequestModel, completion: @escaping (Error?) -> Void) async
}
