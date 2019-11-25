//
//  ViewController.swift
//  TestChart
//
//  Created by Stan Serebryakov on 23.11.2019.
//  Copyright © 2019 Skybonds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var randomSource = RandomDataSource()
    @IBOutlet var chart: PriceYieldChartView?

    override func viewDidLoad() {
        super.viewDidLoad()
        chart?.dataSource = randomSource
        chart?.chartISIN = "ETH-USD"
        // Do any additional setup after loading the view.
    }


}

