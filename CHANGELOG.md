# 1.0.0
* The picker labels now adjust to changes in dynamic font sizes -- fixes a long-standing issue
* Restore default picker font size to Body -- it was accidentally changed to Title 1
* Remove hardcoded 54-point font from IB picker example

# 0.6.0
* Handle picker font size adjustment, fix layout issues - [Rotem Rubnov](https://github.com/rubnov) of [100 Grams Software](https://100grams.io)
* Update project to Xcode 9.4.1 recommended settings
* Access String characters directly, per String changes in Swift 4 ([SE-0163](https://github.com/apple/swift-evolution/blob/master/proposals/0163-string-revision-1.md))

# 0.5.0
* Completely reorganize the file layout to better support SPM, Carthage and Cocoapods, as well as make it easier for users to incorporate
  into their projects
* Centralize the integer and fractional place descriptors, making the code easier to read and maintain
* Prepare for using the Swift Package Manager, even though it does not yet support `UIKit` or `iOS`

# 0.4.0
* Update for Swift 4
* Add accessibility labels to NumericPicker, thus facilitating voice over and UI testing
* Simplify the code by replacing individual NumberFormatter local variables with an instance-level NumberFormatter
* Rename NumericPickerTests to NumericPickerUnitTests

# 0.3.1
* Send '.valueChanged' message only when the numeric value of the picker changes, rather than when other factors (i.e., minimum
  fraction or maximum integer digits changes). This means the 'displayString' will need to be obtained after setting one of these
  properties.

# 0.3.0
* Resolves #1: allow for setting a minimum value for the picker to display
* Update podspec for version 0.3.0

# 0.2.2
* Re-layout the control when `font` is updated

# 0.2.1
* Alphabetize all properties and functions in NumericPicker.swift, and modify the "MARK" comments to be sexier in Xcode

# 0.2.0
* Automatically increase `minIntegerDigits` if `value` is set to something with more than `minIntegerDigits`.
    This prevents picker components from vanishing if the user sets the leftmost component to zero.
* Regardless of where the control is instantiated (code or IB) and how its properties are configured (defaults, code,
    IB), ensure it sized properly.
* Clean up some whitespace
* Fix a stupid typo on the README

# 0.1.3
Document code so Cocoadocs likes it more

# 0.1.2
More Carthage support changes

# 0.1.1
Changes to properly support Carthage

# 0.1.0
Initial public repo
