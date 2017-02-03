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
        print("[\(#function)]")

        super.viewDidLoad()

        totalMileagePicker.value = 12345.0
    }

    override func viewWillAppear(_ animated: Bool) {
        print("[\(#function)]")

        super.viewWillAppear(animated)

        totalMileage.text = totalMileagePicker.displayString
    }

    // MARK: - IB actions

    @IBAction func valueChanged(_ sender: NumericPicker) {
        print("[\(#function)]")
        totalMileage.text = sender.displayString
    }
}
