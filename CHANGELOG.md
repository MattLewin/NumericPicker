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
