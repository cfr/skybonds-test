//
//  TestChartTests.swift
//  TestChartTests
//
//  Created by Stan Serebryakov on 23.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import XCTest
@testable import TestChart

class TestChartTests: XCTestCase {
    
    let range = DateRange.allCases.randomElement()!
    var sample: [Markerable]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sample = RandomDataSource().sampleOf(isin: "TEST", type: .price, in: range)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSampleInRect() {
        let rect = CGRect.randomRect()
        let pointsInRect = sample.mapTo(rect: rect)
        for p in pointsInRect {
            let contains = rect.contains(p)
            XCTAssert(contains)
        }
    }
    
    // ...

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

extension CGRect {
    static func randomRect() -> CGRect {
        let max: CGFloat = 1000.0
        return CGRect(x: CGFloat.random(in: 0.0...max),
                      y: CGFloat.random(in: 0.0...max),
                      width: CGFloat.random(in: 0.0...max),
                      height: CGFloat.random(in: 0.0...max))
    }
}
