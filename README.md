# CBBottomSheet - iOS - Swift - SwiftUI

CBDateRangePicker is a DatePickerView that returns a date range by selecting the start date and the last date.

[![SwiftMP compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-14-blue.svg?style=flat)](https://developer.apple.com/xcode)
[![License](https://img.shields.io/badge/license-mit-brightgreen.svg?style=flat)](https://en.wikipedia.org/wiki/MIT_License)

<img width="300" src="https://github.com/CobyLibrary/CBBottomSheet/assets/57849386/ac7e8575-25bc-43af-a982-394aff1f29f1">

## Requirements

- iOS 13.0+
- Xcode 14.0+
- Swift 5.0+

## Installation

#### Swift Package Manager
```
File -> Swift Packages -> Add Package Dependency

https://github.com/CobyLibrary/CBBottomSheet.git
```

## Usage

### Quick Start

```swift
import CBBottomSheet

struct CBBottomSheetTestView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            
            CBBottomSheet(minHeight: 300, maxHeight: 800) {
                SampleView()
            }

            ...
        }
    }
}
```

### Custom Color Style

```swift
import CBBottomSheet

struct CBBottomSheetTestView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            
            CBBottomSheet(minHeight: 300, maxHeight: 800, backgroundColor: Color.white, indicatorBackgroundColor: Color.gray) {
                SampleView()
            }

            ...
        }
    }
}
```

## Show parameters
```swift
minHeight: CGFloat // Required
maxHeight: CGFloat
backgroundColor: Color
indicatorBackgroundColor: Color
```
