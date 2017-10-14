//
//  DisplayStringTests.swift
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

class DisplayStringTests: XCTestCase {

    static var numericPicker: NumericPicker!
    let displayString: (Double, Int) -> String = {
        (value, fractionDigits) in
        return numericPicker.updatedDisplayString(value: value, fractionDigits: fractionDigits)
    }

    override func setUp() {
        super.setUp()
        DisplayStringTests.numericPicker = NumericPicker(frame: CGRect.zero)
        DisplayStringTests.numericPicker.locale = Locale(identifier: "en-US")
    }

    func testWith0FractionalDigits() {

        let fractionDigits = 0

        XCTContext.runActivity(named: "with a single-digit integer value") { _ in
            let value = 1.0
            XCTAssertEqual(displayString(value, fractionDigits), "1")
        }

        XCTContext.runActivity(named: "with three integers") { _ in
            let value = 123.0
            XCTAssertEqual(displayString(value, fractionDigits), "123")
        }

        XCTContext.runActivity(named: "with the value in tenths place rounded down") { _ in
            let value = 123.4
            XCTAssertEqual(displayString(value, fractionDigits), "123")
        }

        XCTContext.runActivity(named: "with the value in tenths place rounded up") { _ in
            let value = 123.6
            XCTAssertEqual(displayString(value, fractionDigits), "124")
        }

        XCTContext.runActivity(named: "with seven integers") { _ in
            let value = 1234567.0
            XCTAssertEqual(displayString(value, fractionDigits), "1,234,567")
        }

        XCTContext.runActivity(named: "with nine integers") { _ in
            let value = 123456789.0
            XCTAssertEqual(displayString(value, fractionDigits), "123,456,789")
        }

        XCTContext.runActivity(named: "with ten integers") { _ in
            let value = 1234567890.0
            XCTAssertEqual(displayString(value, fractionDigits), "1,234,567,890")
        }

    }


    func testWith1FractionalDigit() {
        let fractionDigits = 1

        XCTContext.runActivity(named: "with zero integer value") { _ in
            let value = 0.9
            XCTAssertEqual(displayString(value, fractionDigits), "0.9")
        }

        XCTContext.runActivity(named: "with four integer digits") { _ in
            let value = 1234.5
            XCTAssertEqual(displayString(value, fractionDigits), "1,234.5")
        }
    }

    func testWith3FractionalDigits() {
        let fractionDigits = 3

        XCTContext.runActivity(named: "with only tenths in value") { _ in
            let value = 123.4
            XCTAssertEqual(displayString(value, fractionDigits), "123.400")
        }

        XCTContext.runActivity(named: "with only hundredths in value") { _ in
            let value = 123.45
            XCTAssertEqual(displayString(value, fractionDigits), "123.450")
        }

        XCTContext.runActivity(named: "with thousandths in value") { _ in
            let value = 123.456
            XCTAssertEqual(displayString(value, fractionDigits), "123.456")
        }
    }

    func testWith4FractionalDigits() {
        let fractionDigits = 4

        XCTContext.runActivity(named: "with four integer value") { _ in
            let value = 1234.5678
            XCTAssertEqual(displayString(value, fractionDigits), "1,234.5678")
        }
    }


    func testInFrenchLocale() {
        DisplayStringTests.numericPicker.locale = Locale(identifier: "fr-FR")

        XCTContext.runActivity(named: "with 0 fractional digits") { _ in
            let fractionDigits = 0

            XCTContext.runActivity(named: "with nine integers") { _ in
                let value = 123456789.0
                XCTAssertEqual(displayString(value, fractionDigits), "123 456 789")
            }

            XCTContext.runActivity(named: "with ten integers") { _ in
                let value = 1234567890.0
                XCTAssertEqual(displayString(value, fractionDigits), "1 234 567 890")
            }
            
        }

        XCTContext.runActivity(named: "with 4 fractional digits") { _ in
            let fractionDigits = 4

            XCTContext.runActivity(named: "with four integers") { _ in
                let value = 1234.5678
                XCTAssertEqual(displayString(value, fractionDigits), "1 234,5678")
            }
        }
    }
}

/*
 TBD:
 - Currency in dollars
 - Currency in non-US currency
 */

