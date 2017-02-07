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

import Quick
import Nimble

@testable import NumericPicker

class ComponentsStringTests: QuickSpec {
    override func spec() {
        describe("updatedComponentsString tests") {
            var numericPicker: NumericPicker!
            let componentsString: (Double, Int, Int) -> String = {
                (value, intDigits, fractionDigits) in
                return numericPicker.updatedComponentString(value: value, intDigits: intDigits, fractionDigits: fractionDigits)
            }


            beforeEach {
                numericPicker = NumericPicker(frame: CGRect.zero)
            }

            context("in en-US locale") {
                beforeEach {
                    numericPicker.locale = Locale(identifier: "en-US")
                }

                context("with 0 fractional digits") {
                    let fractionDigits = 0

                    it("with a single-digit integer value") {
                        let value = 1.0
                        let intDigits = 1
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("1"))
                    }

                    it("with three-integer value and single-integer place") {
                        let value = 123.0
                        let intDigits = 1
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("123"))
                    }

                    it("with two-integer value padded to three places") {
                        let value = 12.3
                        let intDigits = 3
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("012"))
                    }

                    it("with three-integer value padded to six places") {
                        let value = 123.0
                        let intDigits = 6
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("000,123"))
                    }

                    it("with nine-integer value padded to ten places") {
                        let value = 234567890.0
                        let intDigits = 10
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("0,234,567,890"))
                    }
                }

                context("with 1 fractional digit") {
                    let fractionDigits = 1

                    it("with a zero integer value and one integer place") {
                        let value = 0.9
                        let intDigits = 1
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("0.9"))
                    }
                }

                context("with 3 fractional digits") {
                    let fractionDigits = 3

                    it("with a three-integer value padded to four places and hundredths padded to thousandths") {
                        let value = 123.45
                        let intDigits = 4
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("0,123.450"))
                    }
                }
            }

            context("in fr-FR locale") {
                beforeEach {
                    numericPicker.locale = Locale(identifier: "fr-FR")
                }

                context("with 6 fractional digits") {
                    let fractionDigits = 6

                    it("with a four-integer value padded to six places and six decimal places") {
                        let value = 1234.5678
                        let intDigits = 6
                        expect(componentsString(value, intDigits, fractionDigits)).to(equal("001 234,567800"))
                    }
                }
            }
        }
    }
}


    /*
     TBD:
     - Currency in dollars
     - Currency in non-US currency
     */
