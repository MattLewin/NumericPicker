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

@IBDesignable public class NumericPicker: UIControl {

    // MARK: - Properties
    override public var intrinsicContentSize: CGSize {
        return picker.bounds.size
    }

    /// The locale used for numeric presentation. (Defaults to current locale)
    public var locale = Locale.current {
        didSet {
            updatePicker()
        }
    }

    /// The font for the components of the picker. (Defaults to `Body`)
    public var font = UIFont.preferredFont(forTextStyle: .body)

    /// `displayString` is the numeric value selected in the picker without integer zero-padding. It's read-only and 
    /// updated by changes to `value`, `minIntegerDigits`, and `fractionDigits`.
    fileprivate(set) public var displayString: String = "0"

    // MARK: IB inspectable properties
    /// Minimum number of digits to display to the left of the decimal separator
    @IBInspectable public var value: Double = 0.0 {
        didSet {
            updatePicker()
        }
    }

    @IBInspectable public var minIntegerDigits: Int = 1 {
        didSet {
            updatePicker()
        }
    }

    /// Number of digits to display to the right of the decimal separator
    @IBInspectable public var fractionDigits: Int = 0 {
        didSet {
            updatePicker()
        }
    }

    // MARK: Private properties
    /// The `UIPickerView` embedded within this control
    fileprivate(set) var picker: UIPickerView = UIPickerView()
    /// `componentsString` is the numeric value selected in the picker zero-padded to at least `minIntegerDigits`
    /// places. It's updated by changes to `value`, `minIntegerDigits`, and `fractionDigits`.
    fileprivate(set) var componentsString: String = "0"

    // MARK: - Object life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
    }

    convenience public init() {
        self.init(frame: CGRect.zero)
    }

    func widthOfPickerView() -> CGFloat {
        let componentWidth: CGFloat! = picker.delegate?.pickerView!(picker, widthForComponent: 0)
        let componentCount = CGFloat((picker.dataSource?.numberOfComponents(in: picker))!)
        return componentCount * componentWidth + (componentCount - 1) * (componentWidth / 2) // Account for spacing between components
    }

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

    func updatePicker() {
        displayString = updatedDisplayString(value: value, fractionDigits: fractionDigits)
        componentsString = updatedComponentString(value: value,
                                                  intDigits: minIntegerDigits,
                                                  fractionDigits: fractionDigits)

        picker.reloadAllComponents()
        var index = 0

        for char in componentsString.characters {
            // Row is the numeric value of the digit string, or zero for separators
            let row = Int(String(char)) ?? 0
            picker.selectRow(row, inComponent: index, animated: true)
            index += 1
        }
    }
}

// MARK: - UIPickerViewDataSource
extension NumericPicker: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentsString.characters.count
    }

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
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let unicodeScalers = componentsString.unicodeScalars
        let index = unicodeScalers.index(unicodeScalers.startIndex, offsetBy: component)
        let char = componentsString.unicodeScalars[index]

        guard CharacterSet.decimalDigits.contains(char) else {
            return String(char)
        }

        return String(row)
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        pickerLabel.text = title
        pickerLabel.font = font
        pickerLabel.sizeToFit()
        return pickerLabel
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let pickerLabel = self.pickerView(pickerView, viewForRow: 0, forComponent: component, reusing: nil)
        let width = pickerLabel.bounds.width + 8
        return width
    }

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
        sendActions(for: .valueChanged)
    }
}
