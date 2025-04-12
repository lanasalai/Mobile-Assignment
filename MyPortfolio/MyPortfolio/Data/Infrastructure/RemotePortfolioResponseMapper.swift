//
//  RemotePortfolioResponseMapper.swift
//  MyPortfolio
//
//  Created by Lana Salai on 12.4.25..
//

import Foundation

final class RemotePortfolioResponseMapper {
    private static let OK_200 = 200
    
    private struct PortfolioResponse: Decodable {
        let portfolio: RemotePortfolio
    }
    
    enum Error: Swift.Error {
        case unexpectedError
        case invalidData
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> RemotePortfolio {
        guard response.statusCode == OK_200 else {
            throw Error.unexpectedError
        }
        
        guard let portfolioResponse = try? JSONDecoder().decode(PortfolioResponse.self, from: data) else {
            throw Error.invalidData
        }
        
        return portfolioResponse.portfolio
    }
    
}
