//
//  XCTestCase+MemoryLeakTracking.swift
//  MyPortfolioTests
//
//  Created by Lana Salai on 16.4.25..
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
