//
//  ViewController.swift
//  TestChart
//
//  Created by Stan Serebryakov on 23.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var randomSource = RandomDataSource() // TODO: inject source
    @IBOutlet var chart: PriceYieldChartView?

    override func viewDidLoad() {

        super.viewDidLoad()
        chart?.dataSource = randomSource
        chart?.chartISIN = "ETH-USD"
    }

}
