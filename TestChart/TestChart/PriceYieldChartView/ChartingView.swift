//
//  ChartingView.swift
//  TestChart
//
//  Created by Stan Serebryakov on 25.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation
import UIKit

extension DateRange {
    var dateFormat: String {
        switch self {
        case .twoYears, .year:
            return "MMM"
        default:
            return "dd.MM"
        }
    }
}

@IBDesignable
class ChartingView: UIView {
        
    @IBInspectable
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 57, left: 32,
                                                   bottom: 35, right: 17)
    
    public func set(markers: [Markerable], in range: DateRange) {
        self.range = range
        self.markers = markers
        setNeedsDisplay()
    }
    
    private var dateFormatter = DateFormatter()
    
    private var range: DateRange = .week {
        didSet {
            dateFormatter.dateFormat = range.dateFormat
        }
    }
    
    @IBInspectable var lineColor: UIColor = .red
    @IBInspectable var textColor: UIColor = .darkText
    @IBInspectable var gridColor: UIColor = UIColor(white: 0.5, alpha: 0.3)
    
    private var markers: [Markerable] = []
    
    override func prepareForInterfaceBuilder() {
        
        let markers: [Marker] = Array(1...7).map {
            let v = Double($0)
            return Marker(date: Date().addingTimeInterval(v*DateRange.week.interval),
                          value: v)
        }
        self.set(markers: markers, in: .twoMonths)
    }
    
    override func draw(_ rect: CGRect) {
        
        let chartRect = rect.inset(by: insets)
        
        let points = markers.mapTo(rect: chartRect)
        
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
        
        for (v, p) in zip(hBars, hBarsInRect) {
            gridPath.move(to: CGPoint(x: 0.0, y: p))
            gridPath.addLine(to: CGPoint(x: rect.width, y: p))
            drawLabel(text: String(format: "%.0f", v.rounded()),
                      at: CGPoint(x: 0.0 + labelHeight, y: p))
        }
        
        gridPath.move(to: CGPoint(x: 0.0, y: rect.height))
        gridPath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        
        gridColor.setStroke()
        
        gridPath.lineWidth = 1.0
        gridPath.stroke()
    }
    
    lazy var labelAttrs: [NSAttributedString.Key : Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.boldSystemFont(ofSize: 12.0),
            .strokeWidth: -3.0, .strokeColor: UIColor.white,
            .foregroundColor: textColor
        ]
                
        return attrs
    }()
    
    private let labelHeight: CGFloat = 16
    
    private func drawLabel(text: String, at point: CGPoint) {
        
        let attrText = NSAttributedString(string: text, attributes: labelAttrs)
        
        let w: CGFloat = 100.0, h = labelHeight
        let rect = CGRect(x: point.x - w/2.0, y: point.y - h, width: w, height: h)
        attrText.draw(in: rect)
    }
}


