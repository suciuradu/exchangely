//
//  Reusable.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
