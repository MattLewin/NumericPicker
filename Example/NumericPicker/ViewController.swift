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

    // MARK: - Properties
    var codeNumericPicker = NumericPicker()

    // MARK: IB Outlets
    @IBOutlet weak var codePickerStack: UIStackView!
    @IBOutlet weak var codePickerValue: UITextField!

    @IBOutlet weak var ibPickerValue: UITextField!
    @IBOutlet weak var ibNumericPicker: NumericPicker!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ibNumericPicker.value = 12345.6

        codeNumericPicker.minIntegerDigits = 6
        codeNumericPicker.fractionDigits = 3
        codeNumericPicker.value = 76543.21
        codeNumericPicker.locale = Locale(identifier: "de-DE")
        codeNumericPicker.addTarget(self, action: #selector(codeValueChanged), for: .valueChanged)
        codePickerStack.addArrangedSubview(codeNumericPicker)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ibPickerValue.text = ibNumericPicker.displayString
        codePickerValue.text = codeNumericPicker.displayString
    }

    // MARK: - Actions
    func codeValueChanged() {
        codePickerValue.text = codeNumericPicker.displayString
    }

    @IBAction func ibValueChanged(_ sender: NumericPicker) {
        ibPickerValue.text = sender.displayString
    }

}
