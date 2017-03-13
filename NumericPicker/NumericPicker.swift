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
 NumericPicker is a drop-in iOS picker control written in Swift 3. It makes simplifies the creation of pickers that allow
 your users to specify numbers by digit. It automatically uses the proper grouping and decimal separator for the
 current (or specified) locale. You can easily dictate the number of integer and decimal places in the controller.

 ![Sample Video](https://cl.ly/j5XO/Screen%20Recording%202017-02-08%20at%2003.36%20PM.gif)
 */
@IBDesignable public class NumericPicker: UIControl {
    // *** Please alphabetize everything under its respective group ***

    // MARK: - Properties

    /// The font for the components of the picker. (defaults to `Body`)
    public var font = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            picker.reloadAllComponents()
            resize()
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
            updateValue(animated: false)
            resize()
        }
    }

    // MARK: IB inspectable properties

    /// Number of digits to display to the right of the decimal separator (defaults to `0`)
    @IBInspectable public var fractionDigits: Int = 0 {
        didSet {
            updateValue(animated: false)
            resize()
        }
    }

    /// Minimum number of digits to display to the left of the decimal separator (defaults to `1`)
    @IBInspectable public var minIntegerDigits: Int = 1 {
        didSet {
            updateValue(animated: false)
            resize()
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

            updateValue(animated: true)

            guard justInstantiated else { return }
            justInstantiated = false
            resize()
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
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
    }

    /**
     Initializes and returns a newly allocated `NumericPicker` object with the specified frame rectangle.

     - parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to
     the superview in which you plan to add it.
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
    }


    // MARK: - Picker Maintenance

    /**
     Resizes the `NumericPicker` to contain the all components. Called when a property affecting the picker's
     appearance changes.
     */
    func resize() {
        var pickerSize = picker.bounds.size
        pickerSize.width = widthOfPickerView()
        picker.bounds.size = pickerSize
        frame.size = pickerSize
        picker.frame = bounds
    }

    /**

     - parameter value: the new value displayed in the picker
     - parameter intDigits: the number of digits displayed to the **left** of the decimal separator
     - parameter fractionDigits: the number of digits displayed to the **right** of the decimal separator

     - returns: a string used by `NumericPicker`'s `UIPickerViewDataSource` and `UIPickerViewDelegate` to create and
     configure the components of the picker view
     */
    func updatedComponentString(value: Double, intDigits: Int, fractionDigits: Int) -> String {
        let nf = NumberFormatter()
        nf.locale = locale
        nf.minimumIntegerDigits = intDigits
        nf.minimumFractionDigits = fractionDigits
        nf.maximumFractionDigits = fractionDigits
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = true

        let stringValue = nf.string(from: NSNumber(value: value))
        return stringValue ?? nf.string(from: 0)!
    }

    /**

     - parameter value: the new value displayed in the picker
     - parameter fractionDigits: the number of digits displayed to the right of the decimal separator

     - returns: a string formatted for display to the user
     */
    func updatedDisplayString(value: Double, fractionDigits: Int) -> String {
        let nf = NumberFormatter()
        nf.locale = locale
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = fractionDigits
        nf.maximumFractionDigits = fractionDigits
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = true

        let stringValue = nf.string(from: NSNumber(value: value))
        return stringValue ?? nf.string(from: 0)!
    }

    /// Recalculates `displayString` and `componentsString` and refreshes the picker view. Called whenever a property
    /// of the `NumericPicker` changes.
    func updateValue(animated: Bool = true) {
        displayString = updatedDisplayString(value: value, fractionDigits: fractionDigits)
        componentsString = updatedComponentString(value: value,
                                                  intDigits: minIntegerDigits,
                                                  fractionDigits: fractionDigits)

        picker.reloadAllComponents()
        var index = 0

        for char in componentsString.characters {
            // Row is the numeric value of the digit string, or zero for separators
            let row = Int(String(char)) ?? 0
            picker.selectRow(row, inComponent: index, animated: animated)
            index += 1
        }

        sendActions(for: .valueChanged)
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

// MARK: -
extension NumericPicker: UIPickerViewDataSource {

    // MARK: UIPickerViewDataSource

    /**
     Called by the picker view when it needs the number of components.

     - parameter pickerView: The picker view requesting the data.

     - returns: The number of components (or “columns”) that the picker view should display.
     */
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentsString.characters.count
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

// MARK: -

extension NumericPicker: UIPickerViewDelegate {

    // MARK: UIPickerViewDelegate

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

        let nf = NumberFormatter()
        nf.locale = locale
        nf.minimumIntegerDigits = minIntegerDigits
        nf.maximumFractionDigits = fractionDigits
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = true

        let value = nf.number(from: stringValue)
        self.value = value?.doubleValue ?? 0.0

        guard self.value >= minValue else {
            self.value = minValue
            updateValue(animated: true)
            return
        }

        updateValue(animated: false)
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
}
