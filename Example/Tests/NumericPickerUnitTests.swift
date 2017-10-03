//
//  NumericPickerTests.swift
//  NumericPicker
//
//  Created by Matthew Lewin on 2/1/17.
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

import XCTest
@testable import NumericPicker

/// Tests the `NumericPicker` control itself, rather than any discrete functionality.
class NumericPickerTests: XCTestCase {

    class TestingViewController: UIViewController {
        
        @objc func valueChanged(_ sender: NumericPicker) {
            print("[\(#function)]")
        }
    }

    var vc: TestingViewController!
    var picker: NumericPicker!
    
    override func setUp() {
        super.setUp()
        vc = TestingViewController()
        vc.view.frame = CGRect(origin: CGPoint.zero, size: CGSize.init(width: 64, height: 64))
        
        picker = NumericPicker()
        picker.addTarget(vc, action: #selector(TestingViewController.valueChanged(_:)), for: .valueChanged)
        picker.locale = Locale(identifier: "en-US")
        picker.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFontWeightRegular)
        
        vc.view.addSubview(picker)
    }
    
    override func tearDown() {
        picker.removeTarget(vc, action: #selector(TestingViewController.valueChanged(_:)), for: .valueChanged)
        picker.removeFromSuperview()
        picker = nil
        vc = nil
        
        super.tearDown()
    }

    func testSetValue() {
        picker.value = 1234
        XCTAssertEqual(picker.displayString, "1,234")
        XCTAssertEqual(picker.componentsString, "1,234")
    }
    
    func testSetMinIntegerDigits() {
        picker.value = 1234.1
        picker.minIntegerDigits = 6
        XCTAssertEqual(picker.displayString, "1,234")
        XCTAssertEqual(picker.componentsString, "001,234")
    }
    
    func testFractionDigits() {
        picker.value = 1234.567
        picker.fractionDigits = 4
        XCTAssertEqual(picker.displayString, "1,234.5670")
        XCTAssertEqual(picker.componentsString, "1,234.5670")
    }
    
    func testWidthOfPickerSingleComponent() {
        picker.value = 1
        picker.minIntegerDigits = 1
        picker.fractionDigits = 0
        XCTAssertEqual(picker.widthOfPickerView(), 16.0)
    }

    func testWidthOfPickerTwoIntegerComponents() {
        picker.value = 1
        picker.minIntegerDigits = 2
        picker.fractionDigits = 0
        XCTAssertEqual(picker.widthOfPickerView(), 40.0)
    }

    func testWidthOfPickerSingleIntSingleDecimal() {
        picker.value = 1
        picker.minIntegerDigits = 1
        picker.fractionDigits = 1
        XCTAssertEqual(picker.widthOfPickerView(), 64.0)
    }
    
    func testRowSelection() {
        picker.value = 9
        picker.minIntegerDigits = 1
        picker.fractionDigits = 0
        picker.picker.selectRow(2, inComponent: 0, animated: false)
        picker.picker.reloadAllComponents()
        picker.pickerView(picker.picker, didSelectRow: 2, inComponent: 0)
        XCTAssertEqual(picker.displayString, "2")
    }
}

