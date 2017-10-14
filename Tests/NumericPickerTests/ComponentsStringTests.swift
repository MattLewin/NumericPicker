//
//  ComponentsStringTests.swift
//  NumericPicker
//
//  Created by Matthew Lewin on 1/31/17.
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

class ComponentsStringTests: XCTestCase {

    static var numericPicker: NumericPicker!
    let componentsString: (Double, Int, Int) -> String = {
        (value, intDigits, fractionDigits) in
        return numericPicker.updatedComponentString(value: value, intDigits: intDigits, fractionDigits: fractionDigits)
    }

    override func setUp() {
        super.setUp()
        ComponentsStringTests.numericPicker = NumericPicker(frame: CGRect.zero)
        ComponentsStringTests.numericPicker.locale = Locale(identifier: "en-US")
    }

    func testWith0FractionalDigits() {
        let fractionDigits = 0

        XCTContext.runActivity(named: "with a single-digit integer value") { _ in
            let value = 1.0
            let intDigits = 1
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "1")
        }

        XCTContext.runActivity(named: "with three-integer value and single-integer place") { _ in
            let value = 123.0
            let intDigits = 1
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "123")
        }

        XCTContext.runActivity(named: "with two-integer value padded to three places") { _ in
            let value = 12.3
            let intDigits = 3
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "012")
        }

        XCTContext.runActivity(named: "with three-integer value padded to six places") { _ in
            let value = 123.0
            let intDigits = 6
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "000,123")
        }

        XCTContext.runActivity(named: "with nine-integer value padded to ten places") { _ in
            let value = 234567890.0
            let intDigits = 10
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "0,234,567,890")
        }
    }

    func testWith1FractionalDigit() {
        let fractionDigits = 1

        XCTContext.runActivity(named: "with a zero integer value and one integer place") { _ in
            let value = 0.9
            let intDigits = 1
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "0.9")
        }
    }

    func testWith3FractionalDigits() {
        let fractionDigits = 3

        XCTContext.runActivity(named: "with a three-integer value padded to four places and hundredths padded to thousandths") { _ in
            let value = 123.45
            let intDigits = 4
            XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "0,123.450")
        }
    }

    func testInFrenchLocale() {
        ComponentsStringTests.numericPicker.locale = Locale(identifier: "fr-FR")

        XCTContext.runActivity(named: "with 6 fractional digits") { _ in
            let fractionDigits = 6

            XCTContext.runActivity(named: "with a four-integer value padded to six places and six decimal places") { _ in
                let value = 1234.5678
                let intDigits = 6
                XCTAssertEqual(componentsString(value, intDigits, fractionDigits), "001 234,567800")
            }
        }
    }
}
