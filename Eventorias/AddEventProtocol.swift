//
//  AddEventProtocol.swift
//  Eventorias
//
//  Created by Louise Ta on 21/11/2024.
//

import Foundation

protocol AddEventProtocol: AnyObject {
    func addEvent(event: Event, completion: @escaping(Error?) -> Void)
}
