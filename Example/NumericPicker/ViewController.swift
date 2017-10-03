//
//  ViewController.swift
//  NumericPicker
//
//  Created by Matt Lewin on 02/02/2017.
//  Copyright © 2017 MoGroups
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import NumericPicker

class ViewController: UIViewController {

    // MARK: - Properties
    var codeNumericPicker = NumericPicker()

    // MARK: IB Outlets
    @IBOutlet weak var codePickerStack: UIStackView!
    @IBOutlet weak var codePickerValue: UILabel!

    @IBOutlet weak var ibPickerValue: UILabel!
    @IBOutlet weak var ibNumericPicker: NumericPicker!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ibNumericPicker.value = 12345.6

        // Configure a NumericPicker in code
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
    @objc func codeValueChanged() {
        codePickerValue.text = codeNumericPicker.displayString
    }

    @IBAction func ibValueChanged(_ sender: NumericPicker) {
        ibPickerValue.text = sender.displayString
    }

}
