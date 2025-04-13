//
//  URLSessionHTTPClient.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    private struct InvalidResponseError: Error {}
    
    func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(InvalidResponseError()))
            }
        }.resume()
    }
}
