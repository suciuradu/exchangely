//
//  Double+Extension.swift
//  Exchangely
//
//  Created by Suciu Radu on 11.08.2022.
//

import Foundation

extension Double {
    func roundTwoDecimals() -> Double {
        let divisor = pow(10.0, Double(2))
        return (self * divisor).rounded() / divisor
    }
}
