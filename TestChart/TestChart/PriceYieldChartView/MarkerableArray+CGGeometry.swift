//
//  MarkerableArray+CGGeometry.swift
//  TestChart
//
//  Created by Stan Serebryakov on 25.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation
import CoreGraphics

extension Array where Element == Markerable {

    var max: Double {
        reduce(-Double.infinity) { $1.value > $0 ? $1.value : $0 }
    }
    var min: Double {
        reduce(Double.infinity) { $1.value < $0 ? $1.value : $0 }
    }
    var mid: Double {
        (max + min) / 2.0
    }

    func mapTo(rect: CGRect) -> [CGPoint] {

        let spacer = (rect.width - 1) / CGFloat(count - 1)
        let max = self.max
        let min = self.min

        return lazy.enumerated().map { (n, m) in
            let x = rect.minX + spacer*CGFloat(n)
            let normalized = CGFloat((m.value - min) / (max - min))
            let y = rect.minY + (rect.height - 1) * (1.0 - normalized)
            return CGPoint(x: x, y: y)
        }

    }
}
