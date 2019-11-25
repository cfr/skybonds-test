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

    override func awakeFromNib() {
        super.awakeFromNib()
        for button in [switchType, expand] {
            if let bounds = button?.bounds {
                button?.layer.cornerRadius = bounds.height / 2.0
            }
        }
    }

    private func setupTopButtons() {

        guard let switchType = self.switchType,
            let expand = self.expand else {
            print("\(self) is not initialized")
            return
        }
        for button in [switchType, expand] {
            button.layer.shadowColor = UIColor(white: 0.5, alpha: 0.25).cgColor

            button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            button.layer.shadowOpacity = 1.0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 11.5

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
        for range in DateRange.allCases {
            let button = UIButton(type: .system)
            button.setTitle(range.buttonName, for: .normal)
            button.tag = range.rawValue
            rangeButtons.addArrangedSubview(button)
            button.addTarget(self, action: #selector(rangeTouchUp(sender:)),
                                      for: .touchUpInside)
        }
        if let button = rangeButtons.arrangedSubviews.first as? UIButton {
            rangeTouchUp(sender: button)
        }
    }

    private func updateChart() {

        guard let chartingView = chartingView,
            let ds = dataSource,
            let isin = chartISIN else { return }
        let markers = ds.sampleOf(isin: isin, type: type, in: range)
        chartingView.set(markers: markers, in: range)
    }

    @objc func switchTouchUp(sender: UIButton) {

        type = type == .price ? .yield : .price
        sender.setTitle(type.buttonName, for: .normal)

        updateChart()
    }

    @objc func rangeTouchUp(sender: UIButton) {

        guard let range = DateRange.init(rawValue: sender.tag) else {
            print("Can't find range for \(sender)")
            return
        }
        for button in rangeButtons?.arrangedSubviews as? [UIButton] ?? [] {
            button.setTitleColor(.black, for: .normal)
        }
        sender.setTitleColor(.systemBlue, for: .normal)
        select(range: range)
    }

    private func select(range: DateRange) {

        self.range = range
        updateChart()
    }
}

fileprivate extension DateRange {

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

fileprivate extension ChartType {

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
