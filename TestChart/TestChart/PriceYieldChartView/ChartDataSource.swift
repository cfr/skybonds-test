//
//  ChartDataSource.swift
//  TestChart
//
//  Created by Stan Serebryakov on 24.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation


typealias ChartISIN = String

enum DateRange: Int, CaseIterable {
    case week = 1
    case month
    case twoMonths
    case threeMonths
    case sixMonths
    case year
    case twoYears
}

enum ChartType {
    case price
    case yield
}

protocol Markerable {
    var date: Date { get }
    var value: Double { get }
}

protocol ChartDataSource {
    func sampleOf(isin: ChartISIN, type: ChartType, in range: DateRange) -> [Markerable]
}
