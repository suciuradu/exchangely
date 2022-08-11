//
//  Service.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation

protocol Service: AnyObject {
    var networkClient: NetworkClient { get }
    
    init(networkClient: NetworkClient)
}

extension Service {
    func createRequest(for path: String) -> URLRequest {
        var components = networkClient.baseURL
        components.path = path
        guard let url = components.url else { fatalError("The URL couldn't be formed from the specified components: \(components).") }
        
        return URLRequest(url: url)
    }
}
