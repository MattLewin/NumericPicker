# NumericPicker

[![Version](https://img.shields.io/cocoapods/v/NumericPicker.svg?style=flat)](http://cocoapods.org/pods/NumericPicker)
[![License](https://img.shields.io/cocoapods/l/NumericPicker.svg?style=flat)](http://cocoapods.org/pods/NumericPicker)
[![Platform](https://img.shields.io/cocoapods/p/NumericPicker.svg?style=flat)](http://cocoapods.org/pods/NumericPicker)
[![Swift Version](https://img.shields.io/badge/swift-4.2-blue.svg?style=flat)](https://swift.org)
[![CI Status](http://img.shields.io/travis/MattLewin/NumericPicker.svg?style=flat)](https://travis-ci.org/MattLewin/NumericPicker)

[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)](https://cocoapods.org/pods/NumericPicker)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/SPM-not%20yet-red.svg?style=flat)](https://swift.org/package-manager/)

[![GitHub release](https://img.shields.io/github/release/MattLewin/NumericPicker.svg)](https://github.com/MattLewin/NumericPicker/releases)

## Description

NumericPicker is a drop-in iOS picker control written in Swift. It simplifies the creation of pickers that allow
your users to specify numbers by digit. It automatically uses the proper grouping and decimal separator for the
current (or specified) locale. You can easily dictate the number of integer and decimal places in the controller.

![Sample Video](https://cl.ly/j5XO/Screen%20Recording%202017-02-08%20at%2003.36%20PM.gif)

*Note that the "Picker Value" field is there for demonstration purposes only. It is not included in the
`NumericPicker` control.*

---

## Table of Contents

* [Example](#example)
* [Minimum Requirements](#minimum-requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Author](#author)
* [License](#license)

---

## Minimum Requirements
### Version 1.1.x
* Xcode 10
* iOS 12
* Swift 4.2

### Version 1.0.x
* Xcode 9.0
* iOS 10.3

## Example

This repo contains an example project demonstrating how to use the `NumericPicker` control from Interface Builder and
from code.

To run the example project, clone the repo, open `NumericPicker.xcodeproj` and run the `NumericPicker-Example` scheme

## Installation

### CocoaPods

NumericPicker is available through [CocoaPods](http://cocoapods.org). 

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C that simplifies the use of 3rd-party
libraries like `NumericPicker` in your projects.

First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod "NumericPicker"
```

or, for iOS versions 10.3 - 11.4

```ruby
pod "NumericPicker", '~> 1.0.0'
```

Second, install `NumericPicker` into your project:

```bash
pod install
```

### Carthage 

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and
provides you with binary frameworks. 

To integrate `NumericPicker` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "MattLewin/NumericPicker"
```

or, for iOS versions 10.3 - 11.4

```ruby
github "MattLewin/NumericPicker" ~> 1.0.0
```

Run `carthage update` to build the framework and drag the built `NumericPicker.framework` (in Carthage/Build/iOS folder)
into your Xcode project (Linked Frameworks and Libraries in `Targets`).

### Swift Package Manager (SPM)

The [Swift Package Manager](https://github.com/apple/swift-package-manager) does not yet support importing `UIKit` or compilation for
`iOS`. Thus, `NumericPicker` can not yet be used with the SPM.

### Manually

1. Copy `NumericPicker.swift` into your project
2. Have a nice day

## Usage

`NumericPicker` is a subclass of [`UIControl`](https://developer.apple.com/reference/uikit/uicontrol). In this way it
is more like [`UIDatePicker`](https://developer.apple.com/reference/uikit/uidatepicker) than it is like 
[`UIPickerView`](https://developer.apple.com/reference/uikit/uipickerview). What this means for you is that you don't 
need to implement [`UIPickerViewDataSource`](https://developer.apple.com/reference/uikit/uipickerviewdatasource) or
[`UIPickerViewDelegate`](https://developer.apple.com/reference/uikit/uipickerviewdelegate).

*Note that the provided [Example](#example) demonstrates everything detailed below.*

### Configurable Properties

* `value: Double` - The value displayed in the picker. Set this value to update the picker programatically. 
*(Default: 0)*
* `minIntegerDigits: Int` - The minimum number of integer digits (digits to the left of the decimal separator) to
include in the picker. Think of this as zero-padding the picker. If `value` requires more than this minimum, the picker
will automatically meet this requirement. (This is probably not what you want, though.) *(Default: 1)*   
* `fractionDigits: Int` - The number of digits to the right of the decimal separator. `NumericPicker` guarantees
exactly this many fractional digits will be displayed. You can use this to achieve rounding or zero-padding of values
to the right of the decimal separator. *(Default: 0)*
* `locale: Locale` - The locale used to format the numeric values. Use this if you want numbers formatted with
separators other than those used by the device locale. *(Default: current device locale)*
* `font: UIFont` - The font used to format the picker components. *(Default: `Body` text style)*
* `displayString: String` - **READ ONLY** - The text representation of `value`. This string will contain locale-specific
grouping and decimal separators. It will have exactly `fractionDigits` digits to the right of the decimal separator and 
the minimum number of integer places necessary to represent `value`.


### Interface Builder

To use `NumericPicker` with Interface Builder, add a [`UIControl`](https://developer.apple.com/reference/uikit/uicontrol)
to your storyboard or XIB, and then set the "Custom Class" to `NumericPicker`. Connect the "`Value Changed`" event to
a function in your view controller. (Be certain to set the "Type" to `NumericPicker` as shown below.)

![IBAction](https://cl.ly/1s1Q1E3J3w1c/IBAction.png)

Within that function, you can access `sender.displayString` or `sender.value` as needed.   


#### *Cocoapods or Manually*

If you are using Cocoapods or have dropped `NumericPicker.swift` into your code, you can configure `value`,
`minIntegerDigits`, and `fractionDigits` from the "Attributes" inspector.

![IB NumericPicker](https://cl.ly/j5h1/NumericPicker-IB.png)

#### *Carthage*

Xcode does not currently (as of 9.0) support `@IBInspectable` properties from external frameworks. The means
you cannot configure the above properties in IB. You can, however, trick IB into rendering `NumericPicker` with its
default values by adding the following code to one of your view controllers:

```swift
@IBDesignable extension NumericPicker { }
```

### Code

Add a `NumericPicker` control from code as you would any other subview. Here is the code from 
`NumericPicker-Example/ViewController.swift` to produce the bottom sample `NumericPicker`. Note that it is typically unnecessary
to set `locale`, as `NumericPicker` will use the current device locale by default.

```swift
var codeNumericPicker = NumericPicker()
codeNumericPicker.minIntegerDigits = 6
codeNumericPicker.fractionDigits = 3
codeNumericPicker.value = 76543.21
codeNumericPicker.locale = Locale(identifier: "de-DE")
codeNumericPicker.addTarget(self, action: #selector(codeValueChanged), for: .valueChanged)
codePickerStack.addArrangedSubview(codeNumericPicker)

```

## Author

Matt Lewin, matt@mogroups.com

## License

NumericPicker is available under the MIT license. See [LICENSE.md](https://raw.githubusercontent.com/MattLewin/NumericPicker/master/LICENSE.md) 
for more info.




