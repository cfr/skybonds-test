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
        sample = RandomDataSource(size: 1000).sampleOf(isin: "TEST", type: .price,
                                                       in: range)
    }

    override func tearDown() {
    }

    func testSampleInRect() {
        let rect = CGRect.randomRect()
        let pointsInRect = sample.mapTo(rect: rect)
        for p in pointsInRect {
            XCTAssert(rect.contains(p))
        }
    }

    func testMinMax() {
        let values = sample.map { $0.value }
        let (min, max) = (values.min()!, values.max()!)
        XCTAssert(sample.max == max)
        XCTAssert(sample.min == min)
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
