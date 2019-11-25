//
//  ChartingView.swift
//  TestChart
//
//  Created by Stan Serebryakov on 25.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ChartingView: UIView {

    public func set(markers: [Markerable], in range: DateRange) {

        self.range = range
        self.markers = markers
        setNeedsDisplay()
    }

    public var insets: UIEdgeInsets = UIEdgeInsets(top: 57, left: 32,
                                                   bottom: 35, right: 17)
    @IBInspectable
    var lineColor: UIColor = .red
    @IBInspectable
    var textColor: UIColor = .darkText
    @IBInspectable
    var gridColor: UIColor = UIColor(white: 0.5, alpha: 0.3)

    private var dateFormatter = DateFormatter()

    private var range: DateRange = .week {
        didSet {
            dateFormatter.dateFormat = range.dateFormat
        }
    }

    private var markers: [Markerable] = []

    override func draw(_ rect: CGRect) {

        let chartRect = rect.inset(by: insets)

        let points = markers.mapTo(rect: chartRect)

        drawLine(points)
        drawGrid(rect, chartRect, points)
    }

    private func drawLine(_ points: [CGPoint]) {

        guard let firstPoint = points.first else {
            return
        }

        lineColor.setFill()
        lineColor.setStroke()

        let graphPath = UIBezierPath()
        graphPath.move(to: firstPoint)

        for pt in points.dropFirst() {
            graphPath.addLine(to: pt)
        }

        graphPath.lineWidth = 2.0
        graphPath.stroke()
    }

    private func drawGrid(_ rect: CGRect, _ chartRect: CGRect, _ points: [CGPoint]) {

        let gridPath = UIBezierPath()

        for (i, pt) in points.enumerated() {

            // Date
            drawLabel(text: dateFormatter.string(from: markers[i].date),
                      at: CGPoint(x: pt.x, y: rect.height))

            // Vertical bar
            gridPath.move(to: CGPoint(x: pt.x, y: 0.0))
            gridPath.addLine(to: CGPoint(x: pt.x, y: rect.height))

            if i == 0 { continue }

            // Value
            drawLabel(text: String(format: "%.2f", markers[i].value), at: pt)

        }

        // Horizontal bars and labels
        let (top, mid, low) = (markers.max, markers.mid, markers.min)
        let hBars = [low, mid, top]
        let hBarsInRect: [CGFloat] = hBars.map {
            let normalVal = CGFloat((round($0) - low) / (top - low))
            return chartRect.minY + chartRect.height * (1.0 - normalVal)
        }

        for (value, pointY) in zip(hBars, hBarsInRect) {
            gridPath.move(to: CGPoint(x: 0.0, y: pointY))
            gridPath.addLine(to: CGPoint(x: rect.width, y: pointY))
            drawLabel(text: String(format: "%.0f", value.rounded()),
                      at: CGPoint(x: 0.0 + labelSize, y: pointY))
        }

        gridPath.move(to: CGPoint(x: 0.0, y: rect.height))
        gridPath.addLine(to: CGPoint(x: rect.width, y: rect.height))

        gridColor.setStroke()

        gridPath.lineWidth = 1.0
        gridPath.stroke()

    }

    private lazy var labelAttrs: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attrs: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.boldSystemFont(ofSize: 12.0),
            .strokeWidth: -3.0, .strokeColor: UIColor.white,
            .foregroundColor: textColor
        ]

        return attrs
    }()

    private let labelSize: CGFloat = 16 // TODO: calculate actual label size

    private func drawLabel(text: String, at point: CGPoint) {

        let attrText = NSAttributedString(string: text, attributes: labelAttrs)

        let w: CGFloat = 100.0, h = labelSize
        let rect = CGRect(x: point.x - w/2.0, y: point.y - h, width: w, height: h)
        attrText.draw(in: rect)
    }

}

extension ChartingView {

    override func prepareForInterfaceBuilder() {

        let markers: [Marker] = Array(1...7).map {
            let v = Double($0)
            return Marker(date: Date().addingTimeInterval(v*DateRange.week.interval),
                          value: v)
        }
        self.set(markers: markers, in: .twoMonths)
    }
}

fileprivate extension DateRange {

    var dateFormat: String {

        switch self {
        case .twoYears, .year:
            return "MMM"
        default:
            return "dd.MM"
        }
    }
}
