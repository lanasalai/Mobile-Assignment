//
//  HTTPClient.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func perform(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
