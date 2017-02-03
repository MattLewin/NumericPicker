//
//  ViewController.swift
//  NumericPicker
//
//  Created by Matt Lewin on 02/02/2017.
//  Copyright (c) 2017 Matt Lewin. All rights reserved.
//

import UIKit
import NumericPicker

class ViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var totalMileage: UITextField!
    @IBOutlet weak var totalMileagePicker: NumericPicker!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        totalMileagePicker.value = 12345.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalMileage.text = totalMileagePicker.displayString
    }

    // MARK: - IB actions
    @IBAction func valueChanged(_ sender: NumericPicker) {
        totalMileage.text = sender.displayString
    }
}
