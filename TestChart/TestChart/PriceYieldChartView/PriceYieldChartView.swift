//
//  PriceYieldChartView.swift
//  TestChart
//
//  Created by Stan Serebryakov on 24.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PriceYieldChartView: UIView {
        
    public var dataSource: ChartDataSource?
    
    public var type: ChartType = .price
    public var range: DateRange = .week
    
    public var chartISIN: ChartISIN? {
        didSet {
            updateChart()
        }
    }
    
    @IBOutlet weak var contentView: UIView?
    @IBOutlet var chartingView: ChartingView?
    @IBOutlet var switchType: UIButton?
    @IBOutlet var expand: UIButton?
    
    @IBOutlet var rangeButtons: UIStackView?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        loadXIB()
        
        setupRangeButtons()
        setupTopButtons()
        
        
        guard let borderColor = chartingView?.gridColor.cgColor
            else { return }
                
        layer.borderWidth = 1.0
        layer.borderColor = borderColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for b in [switchType, expand] {
            if let bounds = b?.bounds {
                b?.layer.cornerRadius = bounds.height / 2.0 //FIXME: safe?
            }
        }
    }
    
    private func setupTopButtons() {
        
        guard let switchType = self.switchType,
            let expand = self.expand else {
            print("\(self) is not initialized")
            return
        }
        for b in [switchType, expand] {
            b.layer.shadowColor = UIColor(white: 0.5, alpha: 0.25).cgColor
            
            b.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            b.layer.shadowOpacity = 1.0
            b.layer.masksToBounds = false
            b.layer.cornerRadius = 11.5
            
            //TODO: custom UIButton with better hightlight
        }
        switchType.addTarget(self, action: #selector(switchTouchUp(sender:)),
                             for: .touchUpInside)
    }
    
    private func setupRangeButtons() {
        
        guard let rangeButtons = self.rangeButtons else {
            print("\(self) is not initialized")
            return
        }
        for r in DateRange.allCases {
            let button = UIButton(type: .system)
            button.setTitle(r.buttonName, for: .normal)
            button.tag = r.rawValue
            rangeButtons.addArrangedSubview(button)
            button.addTarget(self, action: #selector(rangeTouchUp(sender:)),
                                      for: .touchUpInside)
        }
        if let b = rangeButtons.arrangedSubviews.first as? UIButton {
            rangeTouchUp(sender: b)
        }
    }
    
    private func updateChart() {
        
        guard let cView = chartingView,
            let ds = dataSource,
            let isin = chartISIN else { return }
        let markers = ds.sampleOf(isin: isin, type: type, in: range)
        cView.set(markers: markers, in: range)
    }

    @objc func switchTouchUp(sender: UIButton) {
        
        type = type == .price ? .yield : .price
        sender.setTitle(type.buttonName, for: .normal)
        
        updateChart()
    }
    
    @objc func rangeTouchUp(sender: UIButton) {
        
        guard let r = DateRange.init(rawValue: sender.tag) else {
            print("Can't find range for \(sender)")
            return
        }
        for b in rangeButtons?.arrangedSubviews as? [UIButton] ?? [] {
            //b.isSelected = false
            b.setTitleColor(.black, for: .normal)
        }
        sender.setTitleColor(.systemBlue, for: .normal)
        select(range: r)
    }
        
    private func select(range: DateRange) {
        
        self.range = range
        updateChart()
    }
}

extension DateRange {
    
    var buttonName: String {
        switch self {
        case .week:
            return "1W"
        case .month:
            return "1M"
        case .twoMonths:
            return "2M"
        case .threeMonths:
            return "3M"
        case .sixMonths:
            return "6M"
        case .year:
            return "1Y"
        case .twoYears:
            return "2Y"
        }
    }
}

extension ChartType {
    
    var buttonName: String {
        switch self {
        case .price:
            return "PRICE"
        case .yield:
            return "YIELD"
        }
    }
}

extension UIView {
    
    func loadXIB() {
        
        let bundle = Bundle(for: Self.self)
        let views = bundle.loadNibNamed(String.init(describing: Self.self),
                                        owner: self, options: nil)
        guard let view = views?.first as? UIView else {
            print("Can't load \(Self.self) XIB")
            exit(1)
        }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: view, attribute: $0,
                               relatedBy: .equal, toItem: self,
                               attribute: $0, multiplier: 1, constant: 0)
        })
    }
}
