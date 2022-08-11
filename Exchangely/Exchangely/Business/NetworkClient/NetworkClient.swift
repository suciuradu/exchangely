//
//  NetworkClient.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation
import Alamofire

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    
    // MARK: - Public properties
    
    private(set) lazy var baseURL: URLComponents = {
        var components = URLComponents()
        components.scheme = APIConstants.URL.scheme
        components.host = APIConstants.URL.host
        return components
    }()
    
    // MARK: - Private properties
    
    private let session: Session
    
    private lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    // MARK: - Init
    
    init(session: Session = .default) {
        self.session = session
    }
    
    // MARK: - Logic
    
    private func performRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        session.request(request)
            .validate()
            .response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = response.data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                completion(.success(data))
            }
    }
    
    func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(request) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let object = try self.jsonDecoder.decode(T.self, from: result.get())
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Errors

enum NetworkError: LocalizedError {
    case noData
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "The server returned no data."
        }
    }
}
