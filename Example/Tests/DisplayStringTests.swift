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

import Quick
import Nimble

@testable import NumericPicker

class DisplayStringTests: QuickSpec {
    override func spec() {
        describe("updatedDisplayString tests") {
            var numericPicker: NumericPicker!
            let displayString: (Double, Int) -> String = {
                (value, fractionDigits) in
                return numericPicker.updatedDisplayString(value: value, fractionDigits: fractionDigits)
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
                        expect(displayString(value, fractionDigits)).to(equal("1"))
                    }

                    it("with three integers") {
                        let value = 123.0
                        expect(displayString(value, fractionDigits)).to(equal("123"))
                    }

                    it("with the value in tenths place rounded down") {
                        let value = 123.4
                        expect(displayString(value, fractionDigits)).to(equal("123"))
                    }

                    it("with the value in tenths place rounded up") {
                        let value = 123.6
                        expect(displayString(value, fractionDigits)).to(equal("124"))
                    }

                    it("with seven integers") {
                        let value = 1234567.0
                        expect(displayString(value, fractionDigits)).to(equal("1,234,567"))
                    }

                    it("with nine integers") {
                        let value = 123456789.0
                        expect(displayString(value, fractionDigits)).to(equal("123,456,789"))
                    }

                    it("with ten integers") {
                        let value = 1234567890.0
                        expect(displayString(value, fractionDigits)).to(equal("1,234,567,890"))
                    }

                }

                context("with 1 fractional digit") {
                    let fractionDigits = 1

                    it("with zero integer value") {
                        let value = 0.9
                        expect(displayString(value, fractionDigits)).to(equal("0.9"))
                    }

                    it("with four integer digits") {
                        let value = 1234.5
                        expect(displayString(value, fractionDigits)).to(equal("1,234.5"))
                    }
                }

                context("with 3 fractional digits") {
                    let fractionDigits = 3

                    it("with only tenths in value") {
                        let value = 123.4
                        expect(displayString(value, fractionDigits)).to(equal("123.400"))
                    }

                    it("with only hundredths in value") {
                        let value = 123.45
                        expect(displayString(value, fractionDigits)).to(equal("123.450"))
                    }

                    it("with thousandths in value") {
                        let value = 123.456
                        expect(displayString(value, fractionDigits)).to(equal("123.456"))
                    }
                }

                context("with 4 fractional digits") {
                    let fractionDigits = 4

                    it("with four integer value") {
                        let value = 1234.5678
                        expect(displayString(value, fractionDigits)).to(equal("1,234.5678"))
                    }
                }
            }
            context("in fr-FR locale") {
                beforeEach {
                    numericPicker.locale = Locale(identifier: "fr-FR")
                }

                context("with 0 fractional digits") {
                    let fractionDigits = 0

                    it("with nine integers") {
                        let value = 123456789.0
                        expect(displayString(value, fractionDigits)).to(equal("123 456 789"))
                    }

                    it("with ten integers") {
                        let value = 1234567890.0
                        expect(displayString(value, fractionDigits)).to(equal("1 234 567 890"))
                    }
                    
                }

                context("with 4 fractional digits") {
                    let fractionDigits = 4

                    it("with four integers") {
                        let value = 1234.5678
                        expect(displayString(value, fractionDigits)).to(equal("1 234,5678"))
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
