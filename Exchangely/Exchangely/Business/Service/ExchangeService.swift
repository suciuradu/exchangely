//
//  ExchangeService.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation

final class ExchangeService: Service {
    
    // MARK: - Public Properties
    
    var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public Method

    func exchange(fromCurrency: String,
                  amount: Double,
                  toCurrency: String,
                  completion: @escaping (Result<ExchangeDTO, Error>) -> Void) {
        let path = APIConstants.Path.exchange(fromCurrency: fromCurrency, amount: amount, toCurrency: toCurrency)
        networkClient.performRequest(createRequest(for: path), completion: completion)
    }
}

