//
//  APIConstants.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation


enum APIConstants {
    
    enum URL {
        static let scheme: String = "http"
        static let host: String   = "api.evp.lt"
    }
    
    enum Path {
        static func exchange(fromCurrency: String, amount: Double, toCurrency: String) -> String {
            "/currency/commercial/exchange/\(amount)-\(fromCurrency)/\(toCurrency)/latest"
        }
    }
}
