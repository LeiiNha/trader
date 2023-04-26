//
//  ViewController.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = NetworkService()
        service.fetchStockList()
    }


}

