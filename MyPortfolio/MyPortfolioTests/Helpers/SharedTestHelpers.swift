//
//  SharedTestHelpers.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "", code: 0)
}

func anyURL() -> URL {
    URL(string: "any-url")!
}
