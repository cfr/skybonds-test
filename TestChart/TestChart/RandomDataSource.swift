//
//  RandomDataSource.swift
//  TestChart
//
//  Created by Stan Serebryakov on 24.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation

struct Marker: Markerable {
    
    let date: Date
    let value: Double
}

class RandomDataSource: ChartDataSource {    
    
    func sampleOf(isin: ChartISIN, type: ChartType, in range: DateRange) -> [Markerable] {
        
        return Array(1...7).map { _ in Marker.random(in: range) }
            .sorted { $1.date > $0.date }
    }
}

extension DateRange {
    
    var interval: TimeInterval {
        let day = 24*60*60.0;
        switch self {
        case .week:
            return 7*day;
        case .month:
            return 30*day;
        case .twoMonths:
            return 2*30*day;
        case .threeMonths:
            return 3*30*day;
        case .sixMonths:
            return 6*30*day;
        case .year:
            return 365*day;
        case .twoYears:
            return 2*365*day;
        }
    }
}

extension Marker {
    
    static func random(in range: DateRange) -> Marker {
        let date = Date().addingTimeInterval(-1 * Double.random(in:0.0...range.interval))
        return Marker(date: date, value: Double.random(in:0.0...20.0))
    }
}
