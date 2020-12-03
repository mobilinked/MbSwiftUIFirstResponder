# SwiftUI First Responder

Swift package for controlling the first responder effortlessly.
* SwiftUI style APIs for TextField and TextEditor.
* Tap outside to resign the first responder
* For iOS and macOS apps.

Usage:
```swift
TextField("Name", text: $name)
    .firstResponder(id: FirstResponders.name, firstResponder: $firstResponder, resignableUserOperations: .all)

TextEditor(text: $notes)
    .firstResponder(id: FirstResponders.notes, firstResponder: $firstResponder, resignableUserOperations: .all)
```

[![First Responder Demo](https://img.youtube.com/vi/zcUd2grpoz4/0.jpg)](https://www.youtube.com/watch?v=zcUd2grpoz4)

### Goal: 

While we started enhancing our [QuickPlan](https://quickplan.app) app user interfaces using SwiftUI, we found the first responder controlling impact the user experience very much. 

* Keep using SwiftUI views.
* SwiftUI style API calls to control the first responder. 
* Additional controls for the events like tap outside, escape key pressed.

### Note: 

This package is a temporary solution for controlling the first responder before the official APIs issued by Apple. 
This solution depends on the run-time (UIKit and AppKit) view structure - the code analyzes the run-time views and adds additional controls to the UIKit and AppKit views. 
It may **NOT** work in the future. The method used for this solution may not be possible as the SwiftUI implementation may change.

### Installation:

It requires iOS 14 and macOS 11, and Xcode 12!

In Xcode go to `File -> Swift Packages -> Add Package Dependency` and paste in the repo's url: `https://github.com/Mobilinked/MbSwiftUIFirstResponder`


### Demo: 

Please check the demo codes for iOS and macOS in the [demo folder](Demo)
