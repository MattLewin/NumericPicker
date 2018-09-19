//
//  NumericPicker.swift
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

import UIKit

/**
 NumericPicker is a drop-in iOS picker control written in Swift. It makes simplifies the creation of pickers that allow
 your users to specify numbers by digit. It automatically uses the proper grouping and decimal separator for the
 current (or specified) locale. You can easily dictate the number of integer and decimal places in the controller.

 ![Sample Video](https://cl.ly/j5XO/Screen%20Recording%202017-02-08%20at%2003.36%20PM.gif)
 */
@IBDesignable public class NumericPicker: UIControl {
    // *** Please alphabetize everything under its respective group ***

    // MARK: - Properties

    /// The font for the components of the picker. (defaults to `Body`)
    @IBInspectable public var font = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            picker.reloadAllComponents()
            generateAccessibilityLabels()
        }
    }

    /// `displayString` is the numeric value selected in the picker without integer zero-padding. It's read-only and
    /// updated by changes to `value`, `minIntegerDigits`, and `fractionDigits`.
    fileprivate(set) public var displayString: String = "0"

    /// The natural size for the receiving view, considering only properties of the view itself.
    override public var intrinsicContentSize: CGSize {
        return picker.bounds.size
    }

    /// The locale used for numeric presentation. (defaults to current locale)
    public var locale = Locale.current {
        didSet {
            numberFormatter.locale = locale
            updateAppearance(animated: false)
            generateAccessibilityLabels()
        }
    }

    // MARK: IB inspectable properties

    /// Number of digits to display to the right of the decimal separator (defaults to `0`)
    @IBInspectable public var fractionDigits: Int = 0 {
        didSet {
            updateAppearance(animated: false)
            generateAccessibilityLabels()
        }
    }

    /// Minimum number of digits to display to the left of the decimal separator (defaults to `1`)
    @IBInspectable public var minIntegerDigits: Int = 1 {
        didSet {
            updateAppearance(animated: false)
            generateAccessibilityLabels()
        }
    }

    /// Minimum value the picker may be set to (defaults to `0.0`)
    /// - Warning: Must be zero or greater.
    @IBInspectable public var minValue: Double = 0.0 {
        didSet {
            if minValue < 0.0 {
                minValue = 0.0
            }
        }
    }

    /// The numeric value shown in the picker (defaults to `0.0`)
    @IBInspectable public var value: Double = 0.0 {
        didSet {
            // If value exceeds the maximum integer value representable by minIntegerDigits, increase minIntegerDigits
            // to avoid picker components disappearing if the user sets the leftmost component to zero.
            if Decimal(value) >= pow(10, minIntegerDigits) {
                minIntegerDigits = intDigits(in: value)
            }

            updateAppearance(animated: true)
            sendActions(for: .valueChanged)

            guard justInstantiated else { return }
            justInstantiated = false
        }
    }

    // MARK: Private properties

    /// `componentsString` is the numeric value selected in the picker zero-padded to at least `minIntegerDigits`
    /// places. It's updated by changes to `value`, `minIntegerDigits`, and `fractionDigits`.
    fileprivate(set) var componentsString: String = "0"

    /// When the `NumericPicker` is first instantiated, we want to size it properly according to `value`. After that,
    /// changing `value` shouldn't resize the view.
    private var justInstantiated = true

    /// The `UIPickerView` embedded within this control
    fileprivate(set) var picker: UIPickerView = UIPickerView()

    /// The accessibility labels for each component of the picker
    fileprivate var accessibilityLabels: [String]?

    /// We rely so heavily on `NumberFormatter`, that we keep one instantiated as a property
    fileprivate let numberFormatter = NumberFormatter()

    // MARK: - Object life cycle

    /// Initializes and returns a newly allocated `NumericPicker` object with a zero-sized frame rectangle.
    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    /**
     Returns an object initialized from data in a given unarchiver.

     - parameter aDecoder: An unarchiver object.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /**
     Initializes and returns a newly allocated `NumericPicker` object with the specified frame rectangle.

     - parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to
     the superview in which you plan to add it.
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /**
     Encapsulates the functionality common to all `init` methods of `NumericPicker`
     */
    private func commonInit() {
        numberFormatter.usesGroupingSeparator = true
        picker.delegate = self
        picker.dataSource = self
        picker.isAccessibilityElement = false
        addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: picker, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
    }

    // MARK: - Picker Maintenance

    /**
     Recalculates `displayString` and `componentsString` and refreshes the picker view. Called whenever a property
     of the `NumericPicker` changes.

     - parameter animated: whether to animate the changes to the picker's components (default: `true`)
     */
    func updateAppearance(animated: Bool = true) {
        displayString = updatedDisplayString(value: value, fractionDigits: fractionDigits)
        componentsString = updatedComponentString(value: value,
                                                  intDigits: minIntegerDigits,
                                                  fractionDigits: fractionDigits)

        picker.reloadAllComponents()
        var index = 0

        for char in componentsString {
            // Row is the numeric value of the digit string, or zero for separators
            let row = Int(String(char)) ?? 0
            picker.selectRow(row, inComponent: index, animated: animated)
            index += 1
        }
    }

    /**
     - parameter value: the new value displayed in the picker
     - parameter intDigits: the number of digits displayed to the **left** of the decimal separator
     - parameter fractionDigits: the number of digits displayed to the **right** of the decimal separator

     - returns: a string used by `NumericPicker`'s `UIPickerViewDataSource` and `UIPickerViewDelegate` to create and
     configure the components of the picker view
     */
    func updatedComponentString(value: Double, intDigits: Int, fractionDigits: Int) -> String {
        numberFormatter.minimumIntegerDigits = intDigits
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        numberFormatter.numberStyle = .decimal

        let stringValue = numberFormatter.string(from: NSNumber(value: value))
        return stringValue ?? numberFormatter.string(from: 0)!
    }

    /**
     - parameter value: the new value displayed in the picker
     - parameter fractionDigits: the number of digits displayed to the right of the decimal separator

     - returns: a string formatted for display to the user
     */
    func updatedDisplayString(value: Double, fractionDigits: Int) -> String {
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        numberFormatter.numberStyle = .decimal

        let stringValue = numberFormatter.string(from: NSNumber(value: value))
        return stringValue ?? numberFormatter.string(from: 0)!
    }

    /**
     Calculates the width of the picker based on the number of components.

     - returns: the new width of the picker
     */
    func widthOfPickerView() -> CGFloat {
        let componentWidth: CGFloat! = picker.delegate?.pickerView!(picker, widthForComponent: 0)
        let componentCount = CGFloat((picker.dataSource?.numberOfComponents(in: picker))!)
        return componentCount * componentWidth + (componentCount - 1) * (componentWidth / 2) // Account for spacing between components
    }

    // MARK: - Utility functions

    static let integerPlaceDescriptors = [
        NSLocalizedString("ones", comment: "the ones or units column"),
        NSLocalizedString("tens", comment: "the tens column"),
        NSLocalizedString("hundreds", comment: "the hundreds column"),
        NSLocalizedString("thousands", comment: "the thousands column"),
        NSLocalizedString("ten thousands", comment: "the ten thousands column"),
        NSLocalizedString("hundred thousands", comment: "the hundred thousands column"),
        NSLocalizedString("millions", comment: "the millions column"),
        ]

    static let fractionPlaceDescriptors = [
        NSLocalizedString("tenths", comment: "the tenths (0.1) column"),
        NSLocalizedString("hundredths", comment: "the hundredths (0.01) column"),
        NSLocalizedString("thousandths", comment: "the thousandths (0.001) column"),
        ]

    fileprivate func exponentString(for: FloatingPointSign, magnitude: Int) -> String {
        numberFormatter.maximumIntegerDigits = 1
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.numberStyle = .scientific
        let magnitudeNumber = Decimal(sign: .plus, exponent: magnitude, significand: 1)
        return numberFormatter.string(from: magnitudeNumber as NSDecimalNumber)!
    }

    /**
     Produce the set of accessibility labels based on the number of integer and fraction digits and store them in the
     `accessibilityLabels` property.

     For integer components greater than seven and fraction components greater than three, the label will be represented
     as exponents. (i.e., *1E10* for one trillion and *1E-4* for ten-thousandths.) For everything in between, the label
     will be the descriptor for that digit place. (i.e., "millions" or "tenths")
     */
    fileprivate func generateAccessibilityLabels() {
        let componentParts = componentsString.components(separatedBy: numberFormatter.decimalSeparator)
        let integerPortion = componentParts[0]
        var digitIndex = 1

        accessibilityLabels = integerPortion.map { character -> String in
            guard character != numberFormatter.groupingSeparator.first! else {
                return NSLocalizedString("thousands separator", comment: "the separator between digit groupings")
            }

            let place = minIntegerDigits - digitIndex
            digitIndex += 1
            if place < NumericPicker.integerPlaceDescriptors.count {
                return NumericPicker.integerPlaceDescriptors[place]
            }
            else {
                return exponentString(for: .plus, magnitude: place)
            }
        }

        guard componentParts.count == 2 else { return }

        let fractionPortion = componentParts[1]

        accessibilityLabels?.append(NSLocalizedString("decimal point",
                                                      comment: "the separator between integer and fractional portions"))

        for index in 0..<fractionPortion.count {
            if index < NumericPicker.fractionPlaceDescriptors.count {
                accessibilityLabels?.append(NumericPicker.fractionPlaceDescriptors[index])
            }
            else {
                accessibilityLabels?.append(exponentString(for: .minus, magnitude: index + 1))
            }
        }
    }

    /**

     - parameter value: the number for which to determine the integer digits (say that ten times fast)

     - returns: the number of integer digits in `value`
     */
    private func intDigits(in value: Double) -> Int {
        var intValue = Int(value)
        var digits = 0

        repeat {
            intValue /= 10
            digits += 1
        } while (intValue != 0)

        return digits
    }
}

// MARK: - UIPickerViewAccessibilityDelegate

extension NumericPicker: UIPickerViewAccessibilityDelegate {

    public func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
        return accessibilityLabels?[component] ??
            NSLocalizedString("unknown picker wheel #\(component)", comment: "voice over label for unknown picker component")
    }
}

// MARK: - UIPickerViewDataSource
extension NumericPicker: UIPickerViewDataSource {

    /**
     Called by the picker view when it needs the number of components.

     - parameter pickerView: The picker view requesting the data.

     - returns: The number of components (or “columns”) that the picker view should display.
     */
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentsString.count
    }

    /**
     Called by the picker view when it needs the number of rows for a specified component.

     - parameter pickerView: The picker view requesting the data.
     - parameter component: A zero-indexed number identifying a component of `pickerView`. Components are numbered left-to-right.

     - returns: The number of rows for the component.
     */
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let unicodeScalers = componentsString.unicodeScalars
        let index = unicodeScalers.index(unicodeScalers.startIndex, offsetBy: component)
        let char = componentsString.unicodeScalars[index]

        guard CharacterSet.decimalDigits.contains(char) else {
            return 1
        }

        return 10
    }
}

// MARK: - UIPickerViewDelegate

extension NumericPicker: UIPickerViewDelegate {

    /**
     Called by the picker view when the user selects a row in a component.

     - parameter pickerView: The picker view requesting the data.
     - parameter row: A zero-indexed number identifying a row of `component`. Rows are numbered top-to-bottom.
     - parameter component: A zero-indexed number identifying a component of `pickerView`. Components are numbered left-to-right.
     */
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var stringValue = ""
        for index in 0..<pickerView.numberOfComponents {
            let selectedRow = pickerView.selectedRow(inComponent: index)
            let title = self.pickerView(pickerView, titleForRow: selectedRow, forComponent: index)
            stringValue += title!
        }

        numberFormatter.minimumIntegerDigits = minIntegerDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        numberFormatter.numberStyle = .decimal

        let value = numberFormatter.number(from: stringValue)!.doubleValue
        self.value = (value >= minValue) ? value : minValue
    }

    /**
     Called by the picker view when it needs the title to use for a given row in a given component.

     - parameter pickerView: The picker view requesting the data.
     - parameter row: A zero-indexed number identifying a row of `component`. Rows are numbered top-to-bottom.
     - parameter component: A zero-indexed number identifying a component of `pickerView`. Components are numbered left-to-right.

     - returns: The string to use as the title of the indicated component row.
     */
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let unicodeScalers = componentsString.unicodeScalars

        // Work around a bug in iOS 12 SDK
        if component >= unicodeScalers.count {
            return String(row)
        }

        let index = unicodeScalers.index(unicodeScalers.startIndex, offsetBy: component)
        let char = componentsString.unicodeScalars[index]

        guard CharacterSet.decimalDigits.contains(char) else {
            return String(char)
        }

        return String(row)
    }

    /**
     Called by the picker view when it needs the view to use for a given row in a given component.

     - parameter pickerView: The picker view requesting the data.
     - parameter row: A zero-indexed number identifying a row of `component`. Rows are numbered top-to-bottom.
     - parameter component: A zero-indexed number identifying a component of `pickerView`. Components are numbered left-to-right.
     - parameter view: A view object that was previously used for this row, but is now hidden and cached by the picker view.

     - returns: A view object to use as the content of `row`. The object can be any subclass of UIView, such as UILabel,
     UIImageView, or even a custom view.
     */
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        pickerLabel.text = title
        pickerLabel.font = font
        pickerLabel.adjustsFontForContentSizeCategory = true
        pickerLabel.accessibilityTraits = UIAccessibilityTraits.adjustable
        pickerLabel.accessibilityValue = title
        pickerLabel.sizeToFit()
        return pickerLabel
    }

    /**
     Called by the picker view when it needs the row width to use for drawing row content.

     - parameter pickerView: The picker view requesting the data.
     - parameter component: A zero-indexed number identifying a component of `pickerView`. Components are numbered left-to-right.

     - returns: A `CGFloat` indicating the width of the row in points.
     */
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerLabel = self.pickerView(pickerView, viewForRow: 0, forComponent: component, reusing: nil)
        let width = pickerLabel.bounds.width + 8
        return width
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        let pickerLabel = self.pickerView(pickerView, viewForRow: 0, forComponent: component, reusing: nil)
        let height = pickerLabel.bounds.height + 8
        return height
    }
}
